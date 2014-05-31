//
//  SettingViewController.m
//  lfa viewer
//
//  Created by Chan Heo on 3/23/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "SettingViewController.h"
#import "global_variable.h"
#import "CustomCell.h"

@interface SettingViewController ()
@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.editing = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    bible_files = [[NSMutableArray alloc]init];
    NSArray *temp = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    for(int i=0; i<temp.count; i++)
    {
        // 확장자 제거한 다운로드 받은 바이블 파일 리스트
        [bible_files addObject:[[temp objectAtIndex:i] substringToIndex:[[temp objectAtIndex:i] length]-4]];
    }

    [self arrangeBibleListforMulti];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)arrangeBibleListforMulti
{
    //bible_files_multi = [[NSMutableArray alloc]init];
    bible_files_remain = [[NSMutableArray alloc]init];
    NSString *temp_saved = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_bookname"];
    NSString *BookName = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"];

    for(int i=0; i<bible_files.count; i++)
    {
        if(![temp_saved isEqualToString:[bible_files objectAtIndex:i]])
        {
            // 메인성경빼고 다운로드받은 성경 모두 추가
            //[bible_files_multi addObject:[bible_files objectAtIndex:i]];
            
            // 그중, 역본선택하지 않은 성경 모두 추가
            NSRange range = [BookName rangeOfString:[bible_files objectAtIndex:i]];
            if(range.location == NSNotFound)
                [bible_files_remain addObject:[bible_files objectAtIndex:i]];
        }
    }
    
    //NSLog(@"%@ %@", bible_files, bible_files_remain);
}

//!!TODO: 셋팅은 모두 STATIC하게 설정함
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *section_name = [NSString alloc];
    if(section == 0) // bible selecion
        section_name = @"성경 선택 및 관리";
    else if (section == 1) // another bible
        section_name = @"다중역본 선택";
    else if(section == 2) // fixed setting
        section_name = @"폰트 및 기타 설정";
    
    return section_name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SETTING_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num_cell = 0;
    if(section == 0) // bible selecion
        num_cell = bible_files.count + 1;
    else if (section == 1) // another bible
        num_cell = bible_files.count - 1;
    else if(section == 2) // fixed setting
        num_cell = NUMBER_OF_FIXED_SETTING;
    
    return num_cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    //!!TODO:컬러입히기 static
    if (indexPath.section == 0 && indexPath.row == 0)
        identifier = @"bible_download";
    else if (indexPath.section == 0)
        identifier = @"bible_nonselected";
    else if (indexPath.section == 1)
        identifier = @"bible_nonselected";
    //else if (indexPath.section == 2 && indexPath.row == 0)
    //    identifier = @"font_selector";
    else if (indexPath.section == 2 && indexPath.row == 0)
        identifier = @"font_size";
    else if (indexPath.section == 2 && indexPath.row == 1)
        identifier = @"lineheight_size";
    else if (indexPath.section == 2 && indexPath.row == 2)
        identifier = @"font_color";
    else if (indexPath.section == 2 && indexPath.row == 3)
        identifier = @"reset_readbible";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //section 0
    if(indexPath.section == 0 && indexPath.row != 0)
    {
        NSString *bname = [bible_files objectAtIndex:(indexPath.row-1)];
        if(indexPath.row == selectedCell ||[[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_bookname"] isEqualToString:bname])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //cell.selected = YES;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            //cell.selected = NO;
        }

        cell.textLabel.text = [[global_variable getBibleNameConverter] objectForKey:bname];
    }
    //section 1
    else if(indexPath.section == 1)
    {
        NSArray *a_BookName = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"] componentsSeparatedByString:@"|"];
        int a_BookNameCount = a_BookName.count;
        if([[a_BookName objectAtIndex:0] isEqualToString:@""])
            a_BookNameCount = 0;
        
        // 체크된것
        if(indexPath.row < a_BookNameCount)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = [[global_variable getBibleNameConverter] objectForKey:[a_BookName objectAtIndex:indexPath.row]];
        }
        
        // 체크안된것
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = [[global_variable getBibleNameConverter] objectForKey:[bible_files_remain objectAtIndex:(indexPath.row - a_BookNameCount)]];
        }
    }
    
    //section 2
    else if(indexPath.section == 2)
    {
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0)
        {
            int tempsize = (int)[[NSUserDefaults standardUserDefaults] floatForKey:@"saved_fontsize"];
            cell.customLabel.text = [NSString stringWithFormat:@"(%d)",tempsize];
        }
        if(indexPath.row == 1)
        {
            int lineheightsize = (int)[[NSUserDefaults standardUserDefaults] floatForKey:@"saved_lineheightsize"];
            cell.customLabel.text = [NSString stringWithFormat:@"(%d)",lineheightsize];
        }
        if(indexPath.row == 2)
        {
            int color = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_color"];
            if(color == 2)
                cell.customSwitch.on = YES;
            else
                cell.customSwitch.on = NO;
        }
        if(indexPath.row == 3)
        {
        }
    }
    
    return cell;
}

- (IBAction)stepperValue:(UIStepper *)sender
{
    float tempsize = [[NSUserDefaults standardUserDefaults] floatForKey:@"saved_fontsize"];
    if((tempsize <= 5) && (sender.value == 0))
        return;
    else if((tempsize >= 25) && (sender.value == 2))
        return;
            
    if(sender.value == 2)
        [[NSUserDefaults standardUserDefaults] setFloat:tempsize+1.0 forKey:@"saved_fontsize"];
    else if(sender.value == 0)
        [[NSUserDefaults standardUserDefaults] setFloat:tempsize-1.0 forKey:@"saved_fontsize"];
    
    sender.value = 1;
    [self.tableView reloadData];
}

- (IBAction)lineheight_stepperValue:(UIStepper *)sender
{
    float lineheightsize = [[NSUserDefaults standardUserDefaults] floatForKey:@"saved_lineheightsize"];
    if((lineheightsize <= 8) && (sender.value == 0))
        return;
    else if((lineheightsize >= 20) && (sender.value == 2))
        return;

    if(sender.value == 2)
        [[NSUserDefaults standardUserDefaults] setFloat:lineheightsize+1.0 forKey:@"saved_lineheightsize"];
    else if(sender.value == 0)
        [[NSUserDefaults standardUserDefaults] setFloat:lineheightsize-1.0 forKey:@"saved_lineheightsize"];
    
    sender.value = 1;
    [self.tableView reloadData];
}

- (IBAction)backgroundValue:(UISwitch *)sender
{
    if(sender.on)
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"saved_color"];
    else
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"saved_color"];

    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //성경 선택한 경우
    if(indexPath.section == 0 && indexPath.row > 0)
    {
        self.selectedCell = indexPath.row;
        NSString *bname = [bible_files objectAtIndex:(indexPath.row-1)];
        [[NSUserDefaults standardUserDefaults] setObject:bname forKey:@"saved_bookname"];
        
        [self arrangeBibleListforMulti];
        [self.tableView reloadData];
    }
    //다중역본 선택한 경우
    else if(indexPath.section == 1)
    {
        
        NSArray *a_BookName = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"] componentsSeparatedByString:@"|"];
        int a_BookNameCount = a_BookName.count;
        if([[a_BookName objectAtIndex:0] isEqualToString:@""])
            a_BookNameCount = 0;
        
        NSMutableString *na_BookName = [[NSMutableString alloc] init];
        NSString *sep_bar = @"|";
        
        // 체크된것 (del action)
        if(indexPath.row < a_BookNameCount)
        {
            for(int i=0; i<a_BookNameCount; i++)
            {
                NSString *string = [a_BookName objectAtIndex:indexPath.row];
                if([[a_BookName objectAtIndex:i] isEqualToString:string])
                    continue;
                [na_BookName appendString:[a_BookName objectAtIndex:i]];
                [na_BookName appendString:sep_bar];
            }
            if([na_BookName hasSuffix:sep_bar])
                na_BookName = [na_BookName substringWithRange:NSMakeRange(0, na_BookName.length-1)];
        }
        
        // 체크안된것 (add action)
        else
        {
            NSString *string = [bible_files_remain objectAtIndex:(indexPath.row - a_BookNameCount)];
            na_BookName = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"] stringByAppendingString:[sep_bar stringByAppendingString:string]];
            if([na_BookName hasPrefix:sep_bar])
                na_BookName = [na_BookName substringWithRange:NSMakeRange(1, na_BookName.length-1)];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:na_BookName forKey:@"saved_another_bookname"];
        [self arrangeBibleListforMulti];
        [self.tableView reloadData];
    }
    //옵션
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 2)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"saved_readbible"];
        }
        return;
    }
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if(indexPath.section == 1)
     {
         NSArray *a_BookName = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"] componentsSeparatedByString:@"|"];
         // 체크된것만 이동 가능
         if(indexPath.row < a_BookName.count)
             return YES;
         else
             return NO;
     }
     else
         return NO;	
 }

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     NSArray *a_BookName = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"] componentsSeparatedByString:@"|"];
     NSUInteger fromRow = [fromIndexPath row];
     NSUInteger toRow = [toIndexPath row];
     
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if(indexPath.section == 1)
     {
         NSArray *a_BookName = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"] componentsSeparatedByString:@"|"];
         // 체크된것만 이동 가능
         if(indexPath.row < a_BookName.count)
             return YES;
         else
             return NO;
     }
     else
         return NO;
     
 }
*/
@end
