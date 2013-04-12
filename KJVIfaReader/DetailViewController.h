//
//  DetailViewController.h
//  KJVIfaReader
//
//  Created by chan on 13. 4. 12..
//  Copyright (c) 2013년 chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
