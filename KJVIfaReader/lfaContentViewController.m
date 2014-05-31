//
//  lfaContentViewController.m
//  lfa viewer
//
//  Created by Chan Heo on 3/19/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "lfaContentViewController.h"
#import "lfaSelectionViewController.h"
#import "lfbContainer.h"
#import "DejalActivityView.h"

@implementation lfaContentViewController
@synthesize contents;

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
    _NavigationTitle.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_NavigationTitle addTarget:self action:@selector(bibleSelectorClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];

    bool checkupdate_1051 = [[NSUserDefaults standardUserDefaults] boolForKey:@"updated_1051"];
    bool checkupdate_1052 = [[NSUserDefaults standardUserDefaults] boolForKey:@"updated_1052"];
    int svd_bookid = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_bookid"];
    int svd_chapterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_chapterid"];
    BookName = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_bookname"];
    a_BookName = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_another_bookname"];
    readBible = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"];
    
    if(svd_bookid > 0 && svd_chapterid > 0)
    {
        // 스레드로 돌때 값 못읽는것 방지
        bookid = svd_bookid;
        chapterid = svd_chapterid;
        
        if(!checkupdate_1052) //1.052 업데이트 체크
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"새롭게 제작된 킹제임스 흠정역 2.0 버전이 나왔습니다. 아이폰/아이패드 iOS7.0이상 사용자 분은 앱스토어에서 검색 후 사용 바랍니다. " delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"updated_1052"];
            [self loadContent:BookName bookid:svd_bookid chapterid:svd_chapterid];
        }
        else if(!checkupdate_1051) //1.051 업데이트 체크
        {
            NSString *extension =@"lfa";
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
        
            // lfa 파일이 있으면 모두다 삭제하고 기본 kjv파일 다운로드 후 진행
            NSArray *temp = [fileManager subpathsOfDirectoryAtPath:documentsDirectory error:nil];
            NSEnumerator *e = [temp objectEnumerator];
            NSString *filename;
            while((filename = [e nextObject]))
            {
                if([[filename pathExtension] isEqualToString:extension]) {
                    [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil];
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"성경 파일이 없습니다. 한글KJV흠정역을 기본으로 다운로드 받습니다." delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
            [alert show];
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"다운로드중입니다..."];
            [NSThread detachNewThreadSelector:@selector(lfaDefaultDownloadThread:) toTarget:self withObject:DEFAULT_BIBLE];
            is_firststart = NO;
            // 설정값 초기화
            [[NSUserDefaults standardUserDefaults] setFloat:15.0 forKey:@"saved_fontsize"];
            [[NSUserDefaults standardUserDefaults] setFloat:8.0 forKey:@"saved_lineheightsize"];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"updated_1051"];
        }
        else
            [self loadContent:BookName bookid:svd_bookid chapterid:svd_chapterid];
    }
    // 첫 시작, 기본값 셋팅
    else
    {
        [[NSUserDefaults standardUserDefaults] setFloat:15.0 forKey:@"saved_fontsize"];
        [[NSUserDefaults standardUserDefaults] setFloat:5.0 forKey:@"saved_lineheightsize"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"saved_color"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"saved_another_bookname"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"saved_readbible"];

        if(![lfaContentViewController connectedToInternet])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"처음 성경을 다운로드 받기 위해서는 인터넷 연결이 필요합니다. 인터넷 연결 후 다시 시도하세요" delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
            [alert show];
            is_firststart = YES;
            return;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"성경 파일이 없습니다. 한글KJV흠정역을 기본으로 다운로드 받습니다." delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
            [alert show];
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"다운로드중입니다..."];
            bookid = 1;
            chapterid = 1;
            [NSThread detachNewThreadSelector:@selector(lfaDefaultDownloadThread:) toTarget:self withObject:DEFAULT_BIBLE];
            is_firststart = NO;
        }
        
    }

    UISwipeGestureRecognizer *recognizerL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [recognizerL setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizerL];
                                             
    UISwipeGestureRecognizer *recognizerR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [recognizerR setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:recognizerR];
    
    int color = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_color"];
    if(color == 2)
        self.tableView.backgroundColor = [UIColor blackColor];
    else
        self.tableView.backgroundColor = [UIColor whiteColor];

    //pull to reloaded 출력 (top은 항상 hold)
    [super addPullToRefreshTop];
}
                                             
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.contents = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)lfaDefaultDownloadThread:(id)arg
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.kjv",arg]];
    NSData *datalfa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:LFA_DOWNLOAD_URL,arg]]];
    if(datalfa)
        [datalfa writeToFile:finalPath atomically:YES];
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"다운로드 url주소가 정확하지 않습니다. 개발자에게 문의바랍니다." delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [DejalBezelActivityView removeViewAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:arg forKey:@"saved_bookname"];
    BookName = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_bookname"];
    bookid = 1;
    chapterid = 1;
    [self saveCurrentid];
    
    //가장 최근 목록 출력
    [self loadContent:BookName bookid:bookid chapterid:chapterid];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    chapterid++;
    int MAXchapter = [[[global_variable getNumberofChapterinBook] objectAtIndex:(bookid-1)] intValue];
    if(bookid < 66 && chapterid > MAXchapter)
    {
        bookid++;
        chapterid = 1;
    } else if(bookid >= 66 && chapterid > MAXchapter)
    {
        bookid = 1;
        chapterid = 1;
    }
    
    [self loadContent:BookName bookid:bookid chapterid:chapterid];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    chapterid--;
    if(bookid > 1 && chapterid < 1)
    {
        bookid--;
        chapterid = [[[global_variable getNumberofChapterinBook] objectAtIndex:(bookid-1)] intValue];
    }
    else if(bookid <= 1 && chapterid < 1)
    {
        bookid = 66;
        chapterid = [[[global_variable getNumberofChapterinBook] objectAtIndex:(bookid-1)] intValue];
    }
    
    [self loadContent:BookName bookid:bookid chapterid:chapterid];
}

- (void)bibleSelectorClick:(id)sender
{
    if(is_firststart)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"지정된 성경이 없습니다" delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self performSegueWithIdentifier:@"segueBibleSelect" sender:sender];
        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //segue시 데이터 저장
    [self saveCurrentid];
}

- (void)loadContent:(NSString*)bible_name bookid:(int)book_id chapterid:(int)chapter_id
{
    NSString *string = [NSString stringWithFormat:@"%02d_%03d",book_id, chapter_id];
    NSRange delRange = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] rangeOfString:string];
    if(delRange.location != NSNotFound)
        _NavigationTitle.titleLabel.backgroundColor = [UIColor yellowColor];
    else
        _NavigationTitle.titleLabel.backgroundColor = [UIColor whiteColor];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"로딩중입니다..."];
    [_NavigationTitle setTitle:[NSString stringWithFormat:@"%@ %d장",[[global_variable getNamedBookofBible] objectAtIndex:(book_id-1)], chapter_id] forState:UIControlStateNormal];
    
    NSDictionary *extraParams = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:bible_name,[NSString stringWithFormat:@"%d",book_id],[NSString stringWithFormat:@"%d",chapter_id], nil] forKeys:[NSArray arrayWithObjects:@"bibleName",@"bookId",@"chapterId",nil]];
    [NSThread detachNewThreadSelector:@selector(contentDataCall:) toTarget:self withObject:extraParams];
}

/* Thread for Search Data */
- (void)contentDataCall:(id)arg
{
    NSString *bible_name = [arg objectForKey:@"bibleName"];
    int book_id = [[arg objectForKey:@"bookId"] integerValue];
    int chapter_id = [[arg objectForKey:@"chapterId"] integerValue];
    contents = [[NSMutableArray alloc] init];
    
    // 역본 동시보기 선택시 수행
    if(a_BookName != nil && a_BookName.length > 1)
    {
        NSArray *temp = [[lfbContainer alloc] getWithBible:bible_name Book:book_id Chapter:chapter_id];
        NSArray *sep = [a_BookName componentsSeparatedByString:@"|"];
        NSMutableArray *temp_a = [[NSMutableArray alloc] init];
        for(int i=0; i<sep.count; i++)
        {
            NSArray *temp_b = [[lfbContainer alloc] getWithBible:[sep objectAtIndex:i] Book:book_id Chapter:chapter_id];
            [temp_a addObject:temp_b];
        }
        for (int i=0; i<temp.count; i++)
        {
            [contents addObject:[NSString stringWithFormat:@"%@",[temp objectAtIndex:i]]];
            for(int j=0; j<sep.count; j++)
            {
                NSMutableString *separator = [[NSMutableString alloc] init];
                if(j<5){ // 5개까지만 색을 주자
                    for(int k=0; k<=j; k++)
                        [separator appendString:@"_"];
                }
                [contents addObject:[NSString stringWithFormat:@"%@%@",[[temp_a objectAtIndex:j] objectAtIndex:i],separator]];
            }
        }
    }
    else
        contents = [[lfbContainer alloc] getWithBible:bible_name Book:book_id Chapter:chapter_id];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    [self.tableView reloadData];
    bookid = book_id;
    chapterid = chapter_id;
    //데이터 로드시 저장
    [self saveCurrentid];
    
    //pull to reloaded 출력 (top은 항상 hold)
    //전에쓰던건 release
    [[self.tableView viewWithTag:REMOVE_PULL_RELOAD_BOTTOM_TAG]removeFromSuperview];
    [super addPullToRefreshBottom];
    [self.tableView reloadData];
    
    [DejalBezelActivityView removeViewAnimated:YES];
}

+ (BOOL)connectedToInternet
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    return (URLString != NULL) ? YES : NO;
}

- (void)nonThreadloadContent:(NSString*)bible_name bookid:(int)book_id chapterid:(int)chapter_id
{
    NSString *string = [NSString stringWithFormat:@"%02d_%03d",book_id, chapter_id];
    NSRange delRange = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] rangeOfString:string];
    if(delRange.location != NSNotFound)
        _NavigationTitle.titleLabel.backgroundColor = [UIColor yellowColor];
    else
        _NavigationTitle.titleLabel.backgroundColor = [UIColor whiteColor];
    
    [_NavigationTitle setTitle:[NSString stringWithFormat:@"%@ %d장",[[global_variable getNamedBookofBible] objectAtIndex:(book_id-1)], chapter_id] forState:UIControlStateNormal];

    contents = [[NSMutableArray alloc]init];
    
    // 역본 동시보기 선택시 수행
    if(a_BookName != nil && a_BookName.length > 1)
    {
        NSArray *temp = [[lfbContainer alloc] getWithBible:bible_name Book:book_id Chapter:chapter_id];
        NSArray *sep = [a_BookName componentsSeparatedByString:@"|"];
        NSMutableArray *temp_a = [[NSMutableArray alloc] init];
        for(int i=0; i<sep.count; i++)
        {
            NSArray *temp_b = [[lfbContainer alloc] getWithBible:[sep objectAtIndex:i] Book:book_id Chapter:chapter_id];
            [temp_a addObject:temp_b];
        }
        for (int i=0; i<temp.count; i++)
        {
            [contents addObject:[NSString stringWithFormat:@"%@",[temp objectAtIndex:i]]];
            for(int j=0; j<sep.count; j++)
            {
                NSMutableString *separator = [[NSMutableString alloc] init];
                if(j<5){ // 5개까지만 색을 주자
                    for(int k=0; k<=j; k++)
                        [separator appendString:@"_"];
                }
                [contents addObject:[NSString stringWithFormat:@"%@%@",[[temp_a objectAtIndex:j] objectAtIndex:i],separator]];
            }
        }
    }
    else
        contents = [[lfbContainer alloc] getWithBible:bible_name Book:book_id Chapter:chapter_id];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    [self.tableView reloadData];
    bookid = book_id;
    chapterid = chapter_id;
    //데이터 로드시 저장
    [self saveCurrentid];
    
    //pull to reloaded 출력 (top은 항상 hold)
    //전에쓰던건 release
    [[self.tableView viewWithTag:REMOVE_PULL_RELOAD_BOTTOM_TAG]removeFromSuperview];
    [super addPullToRefreshBottom];
    [self.tableView reloadData];
}

- (void)refreshTop {
    if(is_firststart)
        return;
    [super refreshTop];
    chapterid--;
    if(bookid > 1 && chapterid < 1)
    {
        bookid--;
        chapterid = [[[global_variable getNumberofChapterinBook] objectAtIndex:(bookid-1)] intValue];
    }
    else if(bookid <= 1 && chapterid < 1)
    {
        bookid = 66;
        chapterid = [[[global_variable getNumberofChapterinBook] objectAtIndex:(bookid-1)] intValue];
    }
    
    [self nonThreadloadContent:BookName bookid:bookid chapterid:chapterid];
}

- (void)refreshBottom {
    if(is_firststart)
        return;
    [super refreshBottom];
    chapterid++;
    int MAXchapter = [[[global_variable getNumberofChapterinBook] objectAtIndex:(bookid-1)] intValue];
    if(bookid < 66 && chapterid > MAXchapter)
    {
        bookid++;
        chapterid = 1;
    }
    else if(bookid >= 66 && chapterid > MAXchapter)
    {
        bookid = 1;
        chapterid = 1;
    }
    
    [self nonThreadloadContent:BookName bookid:bookid chapterid:chapterid];
}

+ (UIFont *)fontForCell:(CGFloat) size
{
    return [UIFont systemFontOfSize:size];
}

- (void)saveCurrentid
{
    //데이터 저장
    [[NSUserDefaults standardUserDefaults] setInteger:bookid forKey:@"saved_bookid"];
    [[NSUserDefaults standardUserDefaults] setInteger:chapterid forKey:@"saved_chapterid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveTargetedid:(int)book_id chapterid:(int)chapter_id
{
    //데이터 저장
    [[NSUserDefaults standardUserDefaults] setInteger:book_id forKey:@"saved_bookid"];
    [[NSUserDefaults standardUserDefaults] setInteger:chapter_id forKey:@"saved_chapterid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(is_firststart)
        return [contents count];
    else
        return [contents count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.contents count] == indexPath.row)
        return 60.0f;
    else{
        // 다중역본선택시 프리픽스 지우기
        NSString *content = [self.contents objectAtIndex:indexPath.row];
        NSRange range = NSMakeRange(0, content.length);
        if ([content hasSuffix:@"_____"])
            range = NSMakeRange(0, content.length-5);
        else if ([content hasSuffix:@"____"])
            range = NSMakeRange(0, content.length-4);
        else if ([content hasSuffix:@"___"])
            range = NSMakeRange(0, content.length-3);
        else if ([content hasSuffix:@"__"])
            range = NSMakeRange(0, content.length-2);
        else if ([content hasSuffix:@"_"])
            range = NSMakeRange(0, content.length-1);
        content = [content substringWithRange:range];
    
        float lineheight = [[NSUserDefaults standardUserDefaults] floatForKey:@"saved_lineheightsize"];
        
        UIFont *cellFont = [lfaContentViewController fontForCell:[[NSUserDefaults standardUserDefaults] floatForKey:@"saved_fontsize"]];
        CGSize constraintSize = CGSizeMake(320.0f-(lineheight*2),20000.0f);
        CGSize labelSize = [content sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
    
        return labelSize.height + (lineheight*2);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!is_firststart && ([self.contents count] == indexPath.row))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkCell"];
       
        NSString *string = [NSString stringWithFormat:@"%02d_%03d",bookid,chapterid];
        NSRange delRange = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] rangeOfString:string];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %d장을 읽음표시 합니다",[[global_variable getNamedBookofBible] objectAtIndex:(bookid-1)], chapterid];
        if(delRange.location != NSNotFound)  // 체크된것 (del action) format: 09_012|1_013|03_012|01_019
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else  // 체크안된것 (add action)
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }

    else{
        NSString *content = [self.contents objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell"];
        //!!TODO:컬러입히기 STATIC 값
        NSRange range = NSMakeRange(0, content.length);
        if ([content hasSuffix:@"_____"])
        {   
            cell.textLabel.textColor = [UIColor brownColor];
            range = NSMakeRange(0, content.length-5);
        }
        else if ([content hasSuffix:@"____"])
        {
            cell.textLabel.textColor = [UIColor darkGrayColor];
            range = NSMakeRange(0, content.length-4);
        }
        else if ([content hasSuffix:@"___"])
        {
            cell.textLabel.textColor = [UIColor redColor];
            range = NSMakeRange(0, content.length-3);
        }
        else if ([content hasSuffix:@"__"])
        {   
            cell.textLabel.textColor = [UIColor orangeColor];
            range = NSMakeRange(0, content.length-2);
        }
        else if ([content hasSuffix:@"_"])
        {
            cell.textLabel.textColor = [UIColor blueColor];
            range = NSMakeRange(0, content.length-1);
        }
        else
        {
            int color = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_color"];
            if(color == 2)
                cell.textLabel.textColor = [UIColor whiteColor];
            else
                cell.textLabel.textColor = [UIColor blackColor];
        }
        content = [content substringWithRange:range];
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [lfaContentViewController fontForCell:[[NSUserDefaults standardUserDefaults] floatForKey:@"saved_fontsize"]];
        cell.textLabel.text = content;
    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //성경읽음 체크 선택한경우
    if([self.contents count] == indexPath.row)
    {
        NSArray *a_readBible = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] componentsSeparatedByString:@"|"];
        int a_readBibleCount = a_readBible.count;
        if([[a_readBible objectAtIndex:0] isEqualToString:@""])
            a_readBibleCount = 0;
        
        NSMutableString *na_readBible = [[NSMutableString alloc] init];
        NSString *sep_bar = @"|";
        
        // 체크된것 (del action) format: 9_12|1_13|3_12|1_19
        NSString *string = [NSString stringWithFormat:@"%02d_%03d",bookid,chapterid];
        NSRange delRange = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] rangeOfString:string];
        if(delRange.location != NSNotFound)
        {
            for(int i=0; i<a_readBibleCount; i++)
            {
                if([[a_readBible objectAtIndex:i] isEqualToString:string])
                    continue;
                [na_readBible appendString:[a_readBible objectAtIndex:i]];
                [na_readBible appendString:sep_bar];
            }
            if([na_readBible hasSuffix:sep_bar])
                na_readBible = [na_readBible substringWithRange:NSMakeRange(0, na_readBible.length-1)];
        }
        
        // 체크안된것 (add action)
        else
        {
            na_readBible = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] stringByAppendingString:[sep_bar stringByAppendingString:string]];
            if([na_readBible hasPrefix:sep_bar])
                na_readBible = [na_readBible substringWithRange:NSMakeRange(1, na_readBible.length-1)];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:na_readBible forKey:@"saved_readbible"];
        NSRange Range = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] rangeOfString:string];
        if(Range.location != NSNotFound)
            _NavigationTitle.titleLabel.backgroundColor = [UIColor yellowColor];
        else
            _NavigationTitle.titleLabel.backgroundColor = [UIColor whiteColor];
        
        [self.tableView reloadData];
    }
    
    return;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (BOOL)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if(action == @selector(copy:))
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self.contents objectAtIndex:indexPath.row];
    }
    return YES;
}

@end
