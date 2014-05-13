//
//  SettingViewController.h
//  lfa viewer
//
//  Created by Chan Heo on 3/23/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController
{
    NSMutableArray *bible_files;
    NSMutableArray *bible_files_multi;
    NSMutableArray *bible_files_remain;
    int selectedCell;
}
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (nonatomic,readwrite)int selectedCell;

- (IBAction)stepperValue:(UIStepper *)sender;
- (IBAction)lineheight_stepperValue:(UIStepper *)sender;
- (IBAction)backgroundValue:(UISwitch *)sender;
@end
