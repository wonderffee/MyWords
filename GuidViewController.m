//
//  GuidViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.//

#import "GuidViewController.h"
#import "NOIMGButton.h"
#import "PreSettingNavController.h"
#define GIMG_NUM 7
@interface GuidViewController ()

@end

@implementation GuidViewController
/****************** 单例模式 *********************/
+ (GuidViewController *)sharedGuide
{
    static dispatch_once_t  _singletonPredicate;
    static GuidViewController *_theGuid = nil;
    dispatch_once(&_singletonPredicate, ^{
        _theGuid = [[super allocWithZone:nil]init];
    });
    return _theGuid;
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedGuide];
}
/****************** 单例模式 *********************/
+ (void)show
{
    [[GuidViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[GuidViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[GuidViewController sharedGuide] hideGuide];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/****************** 屏幕 *********************/
- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}
- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}
/****************** 屏幕 *********************/

/****************** 隐藏、显示Guid *********************/
- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
//		self.view.frame = [self offscreenFrame];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[self mainWindow] setRootViewController:self];
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		self.view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}
- (void)guideShown
{
	_animating = NO;
}
- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[GuidViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
    [self removeFromParentViewController];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self mainWindow] setRootViewController:[PreSettingNavController sharedPreSettingController]];
    [self release];
}


/****************** 隐藏、显示Guid *********************/

/****************** Button *********************/
- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/****************** Button *********************/



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.pageScroll.pagingEnabled = YES;
    [[self pageScroll] setBounces:NO];
    [[self pageScroll] setShowsHorizontalScrollIndicator:NO];
    [[self pageScroll] setShowsVerticalScrollIndicator:NO];
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * GIMG_NUM,480);
    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIImageView *imgView;
    for (int i = 0; i < GIMG_NUM; i++) {
        @autoreleasepool {
            imgName = [[NSString alloc]initWithFormat:@"guide_%02d",i+1];
            imgView = [[UIImageView alloc]init];
            [imgView setUserInteractionEnabled:YES];
            imgView.frame = CGRectMake(320*i, 0, 320, 480);
            [imgView setImage:[UIImage imageNamed:imgName]];
            [self.pageScroll addSubview:imgView];
            [imgView release];
            if (i == GIMG_NUM - 1) {
                UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(80.f, 355.f, 15.f, 15.f)];
                [checkButton setImage:[UIImage imageNamed:@"checkBox_selectCheck"] forState:UIControlStateSelected];
                [checkButton setImage:[UIImage imageNamed:@"checkBox_blankCheck"] forState:UIControlStateNormal];
                [checkButton addTarget:self action:@selector(pressCheckButton:) forControlEvents:UIControlEventTouchUpInside];
                [checkButton setSelected:YES];
                [imgView addSubview:checkButton];
                
                NOIMGButton *nextButton = [[NOIMGButton alloc] initWithFrame:CGRectMake(60, 400, 200, 40) style:NVUIGradientButtonStyleDefault];
                [nextButton setText:@"开始使用Iwords" forState:UIControlStateNormal];
                [nextButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
                [imgView addSubview:nextButton];
            }
        }
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
