//
//  lfaSelectionViewController.m
//  lfa viewer
//
//  Created by Chan Heo on 3/21/13.
//  Copyright (c) 2013 Chan Heo. All rights reserved.
//

#import "lfaSelectionViewController.h"
#import "lfaChapterSelectionViewController.h"
#import "global_variable.h"

@interface lfaSelectionViewController ()

@end

@implementation lfaSelectionViewController

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
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIScrollView *lfaSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0,50,screen.size.width,screen.size.height-70)];
    [lfaSV setContentSize:CGSizeMake(screen.size.width, (NUMBER_OF_BIBLE/6)*45)];
    [lfaSV setShowsVerticalScrollIndicator:YES];
    [lfaSV setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:lfaSV];
    
    for (int i=0; i<NUMBER_OF_BIBLE; i++)
    {
        UIButton *abutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        abutton.frame = CGRectMake(12+((i%6)*50),((i/6)*45),44,40);
        
        NSString *string = [NSString stringWithFormat:@"%02d_",i+1];
        NSRange Range = [[[NSUserDefaults standardUserDefaults] stringForKey:@"saved_readbible"] rangeOfString:string];
        if(Range.location != NSNotFound)
            [abutton titleLabel].backgroundColor = [UIColor yellowColor];
        else
            [abutton titleLabel].backgroundColor = [UIColor whiteColor];
        [abutton setTag:i];
        [abutton setTitle:[NSString stringWithFormat:@"%@",[[global_variable getShortedBookofBible] objectAtIndex:i]] forState:UIControlStateNormal];
        [abutton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [lfaSV addSubview:abutton];
    }
}

- (void)buttonClicked:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"segueAlltoChapter" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueAlltoChapter"]) {
        //lfaChapterSelectionViewController *vc = [segue destinationViewController];
        NSInteger tagIndex = [(UIButton *)sender tag];
        [[segue destinationViewController] setNumberofChapter:tagIndex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
