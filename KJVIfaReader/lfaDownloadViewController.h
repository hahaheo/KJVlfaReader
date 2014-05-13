//
//  lfaDownloadViewController.h
//  lfa viewer
//
//  Created by Chan Heo on 3/23/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <UIKit/UIKit.h>

static BOOL is_internet_connectable = YES;
@interface lfaDownloadViewController : UITableViewController
{
    NSArray *bible_files;
    NSMutableArray *availList;
    NSMutableArray *availList_down;
}
@end
