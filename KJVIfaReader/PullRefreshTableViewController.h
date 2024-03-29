//
//  PullRefreshTableViewController.h
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

#import <UIKit/UIKit.h>
#import "global_variable.h"

@interface PullRefreshTableViewController : UITableViewController {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textReleaseTop;
    NSString *textPullTop;
    NSString *textReleaseBottom;
    NSString *textLoadingBottom;
    UIView *refreshHeaderView2;
    UILabel *refreshLabel2;
    UIImageView *refreshArrow2;
    UIActivityIndicatorView *refreshSpinner2;
}

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollViewer;
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, retain) UIView *refreshHeaderView2;
@property (nonatomic, retain) UILabel *refreshLabel2;
@property (nonatomic, retain) UIImageView *refreshArrow2;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner2;
@property (nonatomic, copy) NSString *textPullTop;
@property (nonatomic, copy) NSString *textReleaseTop;
@property (nonatomic, copy) NSString *textPullBottom;
@property (nonatomic, copy) NSString *textReleaseBottom;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)refreshTop;
- (void)refreshBottom;
- (void)addPullToRefreshTop;
- (void)addPullToRefreshBottom;

@end
