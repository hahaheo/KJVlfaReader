//
//  lfaContentViewController.h
//  lfa viewer
//
//  Created by Chan Heo on 3/19/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global_variable.h"
#import "lfaSelectionViewController.h"
#import "PullRefreshTableViewController.h"

@class ifaSelectionViewController;

static NSString * BookName;
static NSString * a_BookName;
static NSString * readBible;
static int bookid;
static int chapterid;
static BOOL is_firststart = NO;

@interface lfaContentViewController : PullRefreshTableViewController
@property (strong, nonatomic) IBOutlet UIButton *NavigationTitle;
@property (strong, nonatomic) NSMutableArray *contents;

- (void)loadContent:(NSString*)biblename bookid:(int)bookid chapterid:(int)chapterid;
+ (void)saveTargetedid:(int)book_id chapterid:(int)chapter_id;
+ (UIFont *)fontForCell:(float)fontsize;
+ (BOOL)connectedToInternet;

@end
