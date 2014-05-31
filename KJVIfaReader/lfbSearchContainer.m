//
//  lfbSearchContainer.m
//  lfa viewer
//
//  Created by Chan Heo on 3/22/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "lfbSearchContainer.h"
#import "global_variable.h"
#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"

@implementation lfbSearchContainer

-(NSArray *)getSearchResult:(NSString *)bible Search:(NSString *)searchString Next:(int)nextLevel
{
    // 잘못된 레벨값 체크
    if(nextLevel > (NUMBER_OF_CHAPTER / SIZE_OF_SEARCHSPACE))
        return nil;
    // 띄어쓰기를 하나의 키워드로 간주
    NSArray *c_searchText = [searchString componentsSeparatedByString:@" "];
    // 특정성경에서만 검색시 서치스페이스 축소
    int i=0, j=0, limitbiblespace=0;
    Boolean shortCheck = NO;
        // 검색어를 모두 찾는다
    for(i=0; i<c_searchText.count; i++)
    {
        if(shortCheck)
            break;
        // 단어 길이가 3보다 크면, skip
        if([[c_searchText objectAtIndex:i] length] > 3)
            continue;
        // 검색어 중에 한국어 또는 영어로 된 약어가 있는지 찾는다
        for (j=0; j<NUMBER_OF_BIBLE; j++)
        {
            if([[[global_variable getShortedBookofBible] objectAtIndex:j] isEqualToString:[c_searchText objectAtIndex:i]])
            {
                limitbiblespace = j+1;
                shortCheck = YES;
            }
            else if([[[global_variable getShortedEngBookofBible] objectAtIndex:j] isEqualToString:[c_searchText objectAtIndex:i]])
            {
                limitbiblespace = j+1;
                shortCheck = YES;
            }
        }
    }
    
    NSString *documentsDirectory = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.kjv", bible]] mode:ZipFileModeUnzip];
    
    NSMutableArray *result_return = [NSMutableArray arrayWithCapacity:(MAX_SEARCH_RESULT)];
    NSArray *lists = [unzipFile listFileInZipInfos];
    int chapter_count = (nextLevel * SIZE_OF_SEARCHSPACE); // nextlevel은 0부터 시작
    int k=0;
    for (FileInZipInfo *info in lists) {
        // 특정성경에서만 검색시 필요없는 파일은 스킵
        if((limitbiblespace != 0) && ![info.name hasPrefix:[NSString stringWithFormat:@"%@%02d_", bible, limitbiblespace]])
            continue;
            
        // 재검색일 경우 앞전에 스캔 내용은 skip
        if(k++ < chapter_count)
            continue;
        
        [unzipFile locateFileInZip:info.name];
        ZipReadStream *read = [unzipFile readCurrentFileInZip];

        NSMutableData *data = [[NSMutableData alloc] initWithLength:BUFFER_SIZE]; // !!TODO: 가변 buffer size require
        [read readDataWithBuffer:data];
        [read finishedReading];
        NSString *temp = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        
        // 검색 알고리즘
        // 전체에서 한번 검색하고 나서 있으면 세부적으로 팔까? 경우에수가 너무 많을듯.
        // 절별로 자르고, 검색한다? 직관적임 하지만 너무 많은 loop..
        NSArray *temp_return = [[temp componentsSeparatedByString:[NSString stringWithFormat:@"\n"]] autorelease];
        
        for(int j=0; j<temp_return.count; j++)
        {
            int i=0;
            for(i=0; i<c_searchText.count; i++)
            {
                NSRange result = [[temp_return objectAtIndex:j] rangeOfString:[c_searchText objectAtIndex:i] options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                if(result.location != NSNotFound)
                    continue;
                else
                    break;
            }
            
            // 검색어가 있을경우
            if(c_searchText.count == i)
            {
                NSRange range = NSMakeRange(2, [[temp_return objectAtIndex:j] length]-2);
                NSString *resultString = [[[temp_return objectAtIndex:j] substringWithRange:range] autorelease];
                [result_return addObject:resultString];
            }
        }
        
        chapter_count++;
        if(chapter_count > SIZE_OF_SEARCHSPACE * (nextLevel+1))
            break;
    }
    
    return result_return;
}
@end
