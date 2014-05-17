//
//  lfaSearchViewController.h
//  lfa viewer
//
//  Created by Chan Heo on 3/22/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <UIKit/UIKit.h>

static int SEARCH_SPACE_LEVEL;
static BOOL is_internet_connectable = YES;

@interface lfaSearchViewController : UIViewController
{
    NSMutableArray *contents;
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textLoading;
    NSString *textPullBottom;
    NSString *textReleaseBottom;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

-(void)doneSearching_Clicked:(id)sender;
@end
