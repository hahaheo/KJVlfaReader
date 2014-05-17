//
//  lfbContainer.m
//  lfa viewer
//
//  Created by Chan Heo on 3/20/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "lfbContainer.h"
#import "global_variable.h"
#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"

@implementation lfbContainer

-(NSMutableArray *)getWithBible:(NSString *)bible Book:(int)book Chapter:(int)chapter
{
    NSString *documentsDirectory = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.kjv", bible]] mode:ZipFileModeUnzip];
    
    NSMutableArray *f_return;
    NSArray *lists = [unzipFile listFileInZipInfos];
    for (FileInZipInfo *info in lists) {
        if([info.name isEqualToString:[NSString stringWithFormat:@"%@%02d_%d.lfb", bible, book, chapter]]) {
            [unzipFile locateFileInZip:info.name];
            ZipReadStream *read = [unzipFile readCurrentFileInZip];
            NSMutableData *data = [[NSMutableData alloc] initWithLength:BUFFER_SIZE]; // !!TODO: 가변 buffer size require
            [read readDataWithBuffer:data];
            [read finishedReading];
            
            NSString *temp = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            f_return = [temp componentsSeparatedByString:[NSString stringWithFormat:@"%02d%@ ", book, [[global_variable getShortedBookofBible] objectAtIndex:(book-1)]]];
            if(f_return.count < 2)
                f_return = [temp componentsSeparatedByString:[NSString stringWithFormat:@"%02d%@ ", book, [[global_variable getShortedEngBookofBible] objectAtIndex:(book-1)]]];
            [f_return removeObjectAtIndex:0];
        }
    }
    
    return f_return;
}
@end
