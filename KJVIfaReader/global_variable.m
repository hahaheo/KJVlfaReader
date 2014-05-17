//
//  global_variable.m
//  lfa viewer
//
//  Created by Chan Heo on 3/20/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "global_variable.h"

@implementation global_variable
@synthesize ShortedBookofBible;
@synthesize ShortedEngBookofBible;
@synthesize NamedBookofBible;
@synthesize NumberofChapterinBook;
@synthesize GroupedNamedBookofBible;
@synthesize BibleNameConverter;
@synthesize DownloadableBibleName;

+(NSArray *) getShortedBookofBible{
    ShortedBookofBible = [NSArray arrayWithObjects:@"창",@"출",@"레",@"민",@"신",@"수",@"삿",@"룻",@"삼상",@"삼하",@"왕상",@"왕하",@"대상",@"대하",@"스",@"느",@"에",@"욥",@"시",@"잠",@"전",@"아",@"사",@"렘",@"애",@"겔",@"단",@"호",@"욜",@"암",@"옵",@"욘",@"미",@"나",@"합",@"습",@"학",@"슥",@"말",@"마",@"막",@"눅",@"요",@"행",@"롬",@"고전",@"고후",@"갈",@"엡",@"빌",@"골",@"살전",@"살후",@"딤전",@"딤후",@"딛",@"몬",@"히",@"약",@"벧전",@"벧후",@"요일",@"요이",@"요삼",@"유",@"계",nil];
    
    return ShortedBookofBible;
}

+(NSArray *) getShortedEngBookofBible{
    ShortedBookofBible = [NSArray arrayWithObjects:@"Gn",@"Ex",@"Lv",@"Nm",@"Dt",@"Jos",@"Jdg",@"Ru",@"1Sm",@"2Sm",@"1Kg",@"2Kg",@"1Ch",@"2Ch",@"Ezr",@"Neh",@"Est",@"Jb",@"Ps",@"Pr",@"Ec",@"Sg",@"Is",@"Jr",@"Lm",@"Ezk",@"Dn",@"Hs",@"Jl",@"Am",@"Ob",@"Jnh",@"Mc",@"Nah",@"Hab",@"Zph",@"Hg",@"Zch",@"Mal",@"Mt",@"Mk",@"Lk",@"Jn",@"Ac",@"Rm",@"1Co",@"2Co",@"Gl",@"Eph",@"Php",@"Col",@"1Th",@"2Th",@"1Tm",@"2Tm",@"Ti",@"Phm",@"Heb",@"Jms",@"1Pt",@"2Pt",@"1Jn",@"2Jn",@"3Jn",@"Jd",@"Rv",nil];
    
    return ShortedBookofBible;
}

+(NSArray *) getNamedBookofBible{
    NamedBookofBible = [NSArray arrayWithObjects:@"창세기",@"출애굽기",@"레위기",@"민수기",@"신명기",@"여호수아",@"사사기",@"룻기",@"사무엘상",@"사무엘하",@"열왕기상",@"열왕기하",@"역대상",@"역대하",@"에스라",@"느헤미야",@"에스더",@"욥기",@"시편",@"잠언",@"전도서",@"아가",@"이사야",@"예레미야",@"예레미야애가",@"에스겔",@"다니엘",@"호세아",@"요엘",@"아모스",@"오바댜",@"요나",@"미가",@"나훔",@"하박국",@"스바냐",@"학개",@"스가랴",@"말라기",@"마태복음",@"마가복음",@"누가복음",@"요한복음",@"사도행전",@"로마서",@"고린도전서",@"고린도후서",@"갈라디아서",@"에베소서",@"빌립보서",@"골로새서",@"데살로니가전서",@"데살로니가후서",@"디모데전서",@"디모데후서",@"디도서",@"빌레몬서",@"히브리서",@"야고보서",@"베드로전서",@"베드로후서",@"요한1서",@"요한2서",@"요한3서",@"유다서",@"요한계시록",nil];
    
    return NamedBookofBible;
}

+(NSArray *) getNumberofChapterinBook{
    NumberofChapterinBook = [NSArray arrayWithObjects:@"50",@"40",@"27",@"36",@"34",@"24",@"21",@"4",@"31",@"24",@"22",@"25",@"29",@"36",@"10",@"13",@"10",@"42",@"150",@"31",@"12",@"8",@"66",@"52",@"5",@"48",@"12",@"14",@"3",@"9",@"1",@"4",@"7",@"3",@"3",@"3",@"2",@"14",@"4",@"28",@"16",@"24",@"21",@"28",@"16",@"16",@"13",@"6",@"6",@"4",@"4",@"5",@"3",@"6",@"4",@"3",@"1",@"13",@"5",@"5",@"3",@"5",@"1",@"1",@"1",@"22",nil];
    
    return NumberofChapterinBook;
}

+(NSArray *) getGroupedNamedBookofBible{
    GroupedNamedBookofBible = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"역사서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"창세기",@"출애굽기",@"레위기",@"민수기",@"신명기",@"여호수아",@"사사기",@"룻기",@"사무엘상",@"사무엘하",@"열왕기상",@"열왕기하",@"역대상",@"역대하",@"에스라",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"시가서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"느헤미아",@"에스더",@"욥기",@"시편",@"잠언",@"전도서",@"아가",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"대선지서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"이사야",@"예레미야",@"예레미야애가",@"에스겔",@"다니엘",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"소선지서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"호세아",@"요엘",@"아모스",@"오바댜",@"요나",@"미가",@"나훔",@"하박국",@"스바냐",@"학개",@"스가랴",@"말라기",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"복음서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"마태복음",@"마가복음",@"누가복음",@"요한복음",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"역사서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"사도행전",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"바울 서신서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"로마서",@"고린도전서",@"고린도후서",@"갈라디아서",@"에베소서",@"빌립보서",@"골로새서",@"데살로니가전서",@"데살로니가후서",@"디모데전서",@"디모데후서",@"디도서",@"빌레몬서",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"공동서신", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"히브리서",@"야고보서",@"베드로전서",@"베드로후서",@"요한1서",@"요한2서",@"요한3서",@"유다서",nil],@"data",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"예언서", @"grouptitle",
                         [NSMutableArray arrayWithObjects:@"요한계시록",nil],@"data",nil]
                        ,nil];
    
    return GroupedNamedBookofBible;
}

+(NSDictionary *) getBibleNameConverter{
    BibleNameConverter = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"KJV흠정역", @"korHKJV",@"영어KJV", @"ENGKJV",@"개역성경", @"korhrv",@"바른성경", @"korktv",@"가톨릭성경", @"korcath",@"영어YLT", @"engylt",@"영어Darby", @"engdrb",@"영어ASV", @"engasv", @"헬라어구약Septuagint", @"grestg", @"헬라어신약Stephanos", @"grestp", @"히브리어구약WLC", @"hebrewwlc", @"히브리어구약BHS", @"hebrewbhs", @"히브리어Modern", @"hebmod", nil];
    
    return BibleNameConverter;
}

+(NSArray *) getDownloadableBibleName{
    DownloadableBibleName = [NSArray arrayWithObjects:@"korHKJV",@"ENGKJV",@"korhrv",@"korktv",@"korcath",@"engylt",@"engdrb",@"engasv",@"grestg",@"grestp",@"hebmod",@"hebrewbhs",@"hebrewwlc",nil];
    
    return DownloadableBibleName;
}

@end
