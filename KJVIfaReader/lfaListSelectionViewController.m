//
//  lfaListSelectionViewController.m
//  lfa viewer
//
//  Created by Chan Heo on 3/21/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "lfaListSelectionViewController.h"
#import "lfaChapterSelectionViewController.h"
#import "global_variable.h"

@interface lfaListSelectionViewController ()

@end

@implementation lfaListSelectionViewController
@synthesize BibleList;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.BibleList = [global_variable getGroupedNamedBookofBible];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.BibleList = nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[BibleList objectAtIndex:section] objectForKey:@"grouptitle"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [BibleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[BibleList objectAtIndex:section] objectForKey:@"data"] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueListtoChapter" sender:indexPath];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<BibleList.count; i++)
        [arr addObject:[[[BibleList objectAtIndex:i] objectForKey:@"data"] objectAtIndex:0]];
    return arr;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueListtoChapter"]) {
        int row_c = 0;
        for(int i=0; i<[(NSIndexPath *)sender section]; i++)
        {
            row_c += [[[BibleList objectAtIndex:i] objectForKey:@"data"] count];
        }
        NSInteger tagIndex = [(NSIndexPath *)sender row] + row_c;
        [[segue destinationViewController] setNumberofChapter:tagIndex];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = [[[BibleList objectAtIndex:indexPath.section] objectForKey:@"data"]objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell"];

    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",content];
    
    return cell;
}

@end
