//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation PullRefreshTableViewController

@synthesize textPullTop, textPullBottom, textReleaseTop, textReleaseBottom, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner, refreshHeaderView2, refreshLabel2, refreshArrow2, refreshSpinner2;

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self != nil) {
    [self setupStrings];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    [self setupStrings];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self != nil) {
    [self setupStrings];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

}

- (void)setupStrings{
    /*
     textPullTop = @"Pull down to Previous Chapter...";
     textReleaseTop = @"Release to Previous Chapter...";
     textPullBottom = @"Pull down to Next Chapter...";
     textReleaseBottom = @"Release to Next Chapter...";
     textLoading = @"Loading...";
     */
    
    textPullTop = @"이전 장으로 이동...";
    textReleaseTop = @"슬라이딩을 마치면 이동합니다";
    textPullBottom = @"다음 장으로 이동...";
    textReleaseBottom = @"슬라이딩을 마치면 이동합니다";
    textLoading = @"읽는중...";
}

- (void)addPullToRefreshTop {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];

    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.textColor = [UIColor grayColor];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.text = self.textPullTop;

    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_t.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;

    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}

- (void)addPullToRefreshBottom {
    refreshHeaderView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView2.backgroundColor = [UIColor clearColor];
    refreshHeaderView2.tag = REMOVE_PULL_RELOAD_BOTTOM_TAG; // for remove
    
    refreshLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel2.textColor = [UIColor grayColor];
    refreshLabel2.backgroundColor = [UIColor clearColor];
    refreshLabel2.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel2.textAlignment = NSTextAlignmentCenter;
    refreshLabel2.text = self.textPullBottom;
    
    refreshArrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_b.png"]];
    refreshArrow2.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2), (floorf(REFRESH_HEADER_HEIGHT - 44) / 2), 27, 44);
    
    refreshSpinner2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner2.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner2.hidesWhenStopped = YES;
    
    [refreshHeaderView2 addSubview:refreshLabel2];
    [refreshHeaderView2 addSubview:refreshArrow2];
    [refreshHeaderView2 addSubview:refreshSpinner2];
    [self.tableView addSubview:refreshHeaderView2];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Header Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textReleaseTop;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else { 
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPullTop;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    } else if (isDragging && scrollView.contentOffset.y+scrollView.frame.size.height > scrollView.contentSize.height) {
        //Bottom Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y+scrollView.frame.size.height > scrollView.contentSize.height + REFRESH_HEADER_HEIGHT) {
                // User is scrolling below the header
                refreshLabel2.text = self.textReleaseBottom;
                [refreshArrow2 layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel2.text = self.textPullBottom;
                [refreshArrow2 layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoadingTop];
    } else if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoadingBottom];
    }
}

- (void)startLoadingTop {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refreshTop];
}

- (void)stopLoadingTop {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } 
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingCompleteTop)];
                     }];
}

- (void)startLoadingBottom {
    isLoading = YES;
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel2.text = self.textLoading;
        refreshArrow2.hidden = YES;
        [refreshSpinner2 startAnimating];
    }];
    
    // Refresh action!
    [self refreshBottom];
}

- (void)stopLoadingBottom {
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    isLoading = NO;
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow2 layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
    completion:^(BOOL finished) {
        [self performSelector:@selector(stopLoadingCompleteBottom)];
    }];
}

- (void)stopLoadingCompleteTop {
    // Reset the header
    refreshLabel.text = self.textPullTop;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)stopLoadingCompleteBottom {
    // Reset the header
    refreshLabel2.text = self.textPullBottom;
    refreshArrow2.hidden = NO;
    [refreshSpinner2 stopAnimating];
    
}

- (void)refreshTop {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoadingTop) withObject:nil afterDelay:1.5];
}

- (void)refreshBottom {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoadingBottom) withObject:nil afterDelay:0];
}

@end
