//
//  lfaChapterSelectionViewController.m
//  lfa viewer
//
//  Created by Chan Heo on 3/21/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "lfaChapterSelectionViewController.h"
#import "lfaContentViewController.h"
#import "global_variable.h"

@interface lfaChapterSelectionViewController ()

@end

@implementation lfaChapterSelectionViewController
@synthesize book_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)buttonClicked:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"selectedChapterandBible" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"selectedChapterandBible"]) {
        NSInteger tagIndex = [(UIButton*)sender tag];
        [lfaContentViewController saveTargetedid:self.book_id chapterid:tagIndex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNumberofChapter:(int)num
{
    NSString *temp = [[global_variable getNumberofChapterinBook] objectAtIndex:num];
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIScrollView *chapterSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0,50,screen.size.width,screen.size.height-70)];
    [chapterSV setContentSize:CGSizeMake(screen.size.width, ([temp integerValue]/6)*45)];
    [chapterSV setShowsVerticalScrollIndicator:YES];
    [chapterSV setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:chapterSV];
    
    for (int i=1; i<=[temp integerValue]; i++)
    {
        UIButton *abutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        abutton.frame = CGRectMake(12+((i-1)%6)*50,((i-1)/6)*45,44,40);
        
        NSString *string = [NSString stringWithFormat:@"%02d_%03d",num+1,i];
        NSRange Range = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] rangeOfString:string];
        if(Range.location != NSNotFound)
            [abutton titleLabel].backgroundColor = [UIColor yellowColor];
        else
            [abutton titleLabel].backgroundColor = [UIColor whiteColor];
        
        [abutton setTag:i];
        [abutton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [abutton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [chapterSV addSubview:abutton];
    }
    
    self.navi_title.title = [[global_variable getNamedBookofBible] objectAtIndex:num];
    self.book_id = num+1;
}

@end
