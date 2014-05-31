//
//  CustomCell.m
//  lfa viewer
//
//  Created by Chan Heo on 3/23/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize customSwitch;
@synthesize customLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
