//
//  lfaSearchViewController.m
//  lfa viewer
//
//  Created by Chan Heo on 3/22/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "global_variable.h"
#import "lfaSearchViewController.h"
#import "lfaContentViewController.h"
#import "lfbContainer.h"
#import "lfbSearchContainer.h"
#import "DejalActivityView.h"
#import <QuartzCore/QuartzCore.h>

@interface lfaSearchViewController ()

@end

@implementation lfaSearchViewController

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
    contents = [[NSMutableArray alloc]init];
    SEARCH_SPACE_LEVEL = 0;
    self.closeButton.action = @selector(closeButtonTap);
    [self setupStrings];
    
    int color = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_color"];
    if(color == 2)
        self.resultTableView.backgroundColor = [UIColor blackColor];
    else
        self.resultTableView.backgroundColor = [UIColor whiteColor];
    
    if(![lfaContentViewController connectedToInternet])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"지정된 성경이 없으므로 검색을 사용할수 없습니다" delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
        [alert show];
        is_internet_connectable = NO;
        return;
    }
    else
        is_internet_connectable = YES;
}

- (void)setupStrings{
    textPullBottom = @"더 검색하기...";
    textReleaseBottom = @"슬라이딩을 마치면 검색합니다";
    textLoading = @"읽는중...";
}

-(IBAction)closeButtonTap
{
    [self.searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"segueCloseButton" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    contents = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    if(!is_internet_connectable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"지정된 성경이 없으므로 검색을 사용할수 없습니다" delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if(self.searchBar.text.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"검색어는 2자 이상 작성해야 합니다" message:@"" delegate:nil cancelButtonTitle:@"닫기" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"검색에 많은 시간이 소요될수 있습니다\n아이폰5의 경우 최대 2분이 소요됩니다"];
    [self.searchBar resignFirstResponder];
    contents = [[NSMutableArray alloc]init]; // init.
    SEARCH_SPACE_LEVEL = 0;
    
    [NSThread detachNewThreadSelector:@selector(searchDataCall:) toTarget:self withObject:nil];
}

/* Thread for Search Data */
-(void) searchDataCall: (id)arg
{
    NSString *searchText = self.searchBar.text;
    NSString *BookName = [[NSUserDefaults standardUserDefaults] stringForKey:@"saved_bookname"];
    NSArray *temp = [[lfbSearchContainer alloc] getSearchResult:BookName Search:searchText Next:SEARCH_SPACE_LEVEL];
    // 만약에 검색결과가 1개 미만이면 서치스페이스 자동으로 늘려서 검색한다
    while (temp.count < 1)
    {
        SEARCH_SPACE_LEVEL++;
        temp = [[lfbSearchContainer alloc] getSearchResult:BookName Search:searchText Next:SEARCH_SPACE_LEVEL];
        if(SEARCH_SPACE_LEVEL >= (NUMBER_OF_CHAPTER / SIZE_OF_SEARCHSPACE))
            break;
    }
    
    // 결과에 검색한것 추가
    for(int i=0; i<temp.count; i++)
        [contents addObject:[temp objectAtIndex:i]];

    [self.resultTableView reloadData];
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self.resultTableView viewWithTag:REMOVE_PULL_RELOAD_BOTTOM_TAG]removeFromSuperview];
    // 검색범위를 넘으면 리플래시 출력 중단
    if(SEARCH_SPACE_LEVEL < (NUMBER_OF_CHAPTER / SIZE_OF_SEARCHSPACE))
        [self addPullToRefreshBottom];
    
    return;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [contents count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
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
        pasteboard.string = [contents objectAtIndex:indexPath.row];
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [contents objectAtIndex:indexPath.row];
    float lineheight = [[NSUserDefaults standardUserDefaults] floatForKey:@"saved_lineheightsize"];
    UIFont *cellFont = [lfaContentViewController fontForCell:[[NSUserDefaults standardUserDefaults] floatForKey:@"saved_fontsize"]];
    CGSize constraintSize = CGSizeMake(320.0f-(lineheight*2),20000.0f);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
    
    return labelSize.height + (lineheight*2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = [contents objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell"];

    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [lfaContentViewController fontForCell:[[NSUserDefaults standardUserDefaults] floatForKey:@"saved_fontsize"]];
    cell.textLabel.text = content;
    
    int color = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_color"];
    if(color == 2)
        cell.textLabel.textColor = [UIColor whiteColor];
    else
        cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}


/*for refresh*/
- (void)addPullToRefreshBottom {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.resultTableView.contentSize.height, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    refreshHeaderView.tag = REMOVE_PULL_RELOAD_BOTTOM_TAG; // for remove
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.textColor = [UIColor grayColor];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.text = textPullBottom;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_b.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2), (floorf(REFRESH_HEADER_HEIGHT - 44) / 2), 27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.resultTableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Header Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.resultTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.resultTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y+scrollView.frame.size.height > scrollView.contentSize.height) {
        //Bottom Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y+scrollView.frame.size.height > scrollView.contentSize.height + REFRESH_HEADER_HEIGHT) {
                // User is scrolling below the header
                refreshLabel.text = textReleaseBottom;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = textPullBottom;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + REFRESH_HEADER_HEIGHT) {
        if(SEARCH_SPACE_LEVEL >= (NUMBER_OF_CHAPTER / SIZE_OF_SEARCHSPACE))
            return;
        if(self.searchBar.text.length < 2)
            return;
        // Released above the header
        [self startLoadingBottom];
    }
}

- (void)startLoadingBottom {
    isLoading = YES;
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.resultTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refreshBottom];
}

- (void)stopLoadingBottom {
    isLoading = NO;
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.resultTableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingCompleteBottom)];
                     }];
}

- (void)stopLoadingCompleteBottom {
    // Reset the header
    refreshLabel.text = textPullBottom;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
    
}

- (void)refreshBottom {
    [self performSelector:@selector(stopLoadingBottom) withObject:nil afterDelay:0];
    
    SEARCH_SPACE_LEVEL++;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"더 많은 성경을 검색중입니다\n검색에 많은 시간이 소요될수 있습니다"];
    [NSThread detachNewThreadSelector:@selector(searchDataCall:) toTarget:self withObject:nil];
}


@end
