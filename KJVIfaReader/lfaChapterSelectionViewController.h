//
//  lfaChapterSelectionViewController.h
//  lfa viewer
//
//  Created by Chan Heo on 3/21/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <UIKit/UIKit.h>

static int book_id;
@interface lfaChapterSelectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navi_title;
@property int book_id;

-(void)setNumberofChapter:(int)num;
@end
