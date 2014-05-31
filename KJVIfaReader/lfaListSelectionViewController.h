//
//  lfaListSelectionViewController.h
//  lfa viewer
//
//  Created by Chan Heo on 3/21/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lfaListSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *BibleList;
@end
