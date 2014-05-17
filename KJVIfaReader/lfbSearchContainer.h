//
//  lfbSearchContainer.h
//  lfa viewer
//
//  Created by Chan Heo on 3/22/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lfbSearchContainer : NSObject

-(NSArray *)getSearchResult:(NSString *)bible Search:(NSString *)searchString Next:(int)nextLevel;
@end
