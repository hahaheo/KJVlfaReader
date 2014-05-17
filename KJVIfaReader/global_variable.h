//
//  global_variable.h
//  lfa viewer
//
//  Created by Chan Heo on 3/20/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REMOVE_PULL_RELOAD_BOTTOM_TAG 1234
#define BUFFER_SIZE 65535
#define MAX_SEARCH_RESULT 300
#define SIZE_OF_SEARCHSPACE 200
#define REFRESH_HEADER_HEIGHT 52.0f
#define NUMBER_OF_BIBLE 66
#define NUMBER_OF_CHAPTER 1189
#define NUMBER_OF_SETTING_SECTION 3
#define NUMBER_OF_FIXED_SETTING 4
#define LFA_DOWNLOAD_URL @"http://hahaheo.iptime.org/kjvBibles/%@.kjv"
#define DEFAULT_BIBLE @"korHKJV"

static NSArray *ShortedBookofBible;
static NSArray *ShortedEngBookofBible;
static NSArray *NamedBookofBible;
static NSArray *NumberofChapterinBook;
static NSArray *GroupedNamedBookofBible;
static NSDictionary *BibleNameConverter;
static NSArray *DownloadableBibleName;

@interface global_variable : NSObject
@property(strong,atomic) NSArray *ShortedBookofBible;
@property(strong,atomic) NSArray *ShortedEngBookofBible;
@property(strong,atomic) NSArray *NamedBookofBible;
@property(strong,atomic) NSArray *NumberofChapterinBook;
@property(strong,atomic) NSArray *GroupedNamedBookofBible;
@property(strong,atomic) NSDictionary *BibleNameConverter;
@property(strong,atomic) NSArray *DownloadableBibleName;

+(NSArray *)getShortedBookofBible;
+(NSArray *)getShortedEngBookofBible;
+(NSArray *)getNamedBookofBible;
+(NSArray *)getNumberofChapterinBook;
+(NSArray *)getGroupedNamedBookofBible;
+(NSDictionary *)getBibleNameConverter;
+(NSArray *)getDownloadableBibleName;

@end
