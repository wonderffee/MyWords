//
//  LearningViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-11-20.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "LearningViewController.h"
#import "NewWordsViewController.h"
#define  HAVEN_LEARN   356
@interface LearningViewController ()
{
    NSTimer * _theTimer;
}
@end

@implementation LearningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initProThings
{
    
    UIView * selfView = [self view];

    _theCircularProgress = [[DACircularProgressView alloc]initWithFrame:CGRectMake(60, 60, 200, 200)];
    [_theCircularProgress setThicknessRatio:0.25f];
    [_theCircularProgress setRoundedCorners:YES];
    [_theCircularProgress setProgress:0.0f];
    [_theCircularProgress setProgressTintColor:NAV_TINT_COLOR];
    
    [selfView addSubview:_theCircularProgress];
    
    _percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 200, 200)];
    [_percentLabel setBackgroundColor:[UIColor clearColor]];
    [_percentLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSInteger totalNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"curTotalNumber"];
    NSInteger learenedNum = [[NSUserDefaults standardUserDefaults]integerForKey:@"LearnedNum"];
    _curPercent = (CGFloat)learenedNum / (CGFloat)totalNum;
    
    NSString * perStr = [[NSString alloc]initWithFormat:@"%.4f%c",_curPercent*100,'%'];
    NSLog(@"%f\n",_curPercent);
    [_percentLabel setText:perStr];
    [perStr release];
    perStr = nil;
    
    _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 280, 200, 60)];
    NSString * progressStr = [[NSString alloc]initWithFormat:@"学习进度：%i%c%i",learenedNum,'/',totalNum];
    [_progressLabel setText:progressStr];
    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_progressLabel setBackgroundColor:[UIColor clearColor]];
    
    [progressStr release];
    progressStr = nil;
    
    [selfView addSubview:_progressLabel];
    [selfView addSubview:_percentLabel];
    
    
    
    _nextButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(60, 360, 200, 40) style:NVUIGradientButtonStyleBlackTranslucent];
    [_nextButton setText:@"开始新的学习"];
    [_nextButton setBorderColor:MAIN_BG_COLOR forState:UIControlStateNormal];
    [_nextButton setBorderColor:MAIN_BG_COLOR forState:UIControlStateHighlighted];
    [_nextButton setTintColor:NAV_TINT_COLOR forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextButtontouchedDown:) forControlEvents:UIControlEventTouchDown];
    [_nextButton addTarget:self action:@selector(nextButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [selfView addSubview:_nextButton];
    
    selfView = nil;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self navigationItem] setTitle:@"学习新词"];
    [[self view] setBackgroundColor:MAIN_BG_COLOR];
    
    [self initProThings];
    [self startAnimation];
    
}
-(void)startAnimation
{
    _theTimer  = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    
}
-(void)stopAnimation
{
    [_theTimer invalidate];
}
-(void)progressChange
{
    DACircularProgressView * curCircular = [self theCircularProgress];
    CGFloat progress = [curCircular progress] + 0.005f;

    if (progress <= [self curPercent]) {
        [curCircular setProgress:progress animated:YES];
    }else
    {
        [self stopAnimation];
    }
    
    curCircular  = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)nextButtontouchedDown:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [SVProgressHUD showInView:[self view] status:@"努力加载中..." networkIndicator:YES posY:-1 maskType:SVProgressHUDMaskTypeGradient];
}
-(void)nextButtonTouched:(id)sender
{
    NewWordsViewController *theNew = [[NewWordsViewController alloc]init];
    [[self navigationController] pushViewController:theNew animated:YES];
    [theNew release];
    theNew = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD dismiss];

}
-(void)dealloc
{
    [_progressLabel release];
    [_percentLabel release];
    [_theCircularProgress release];
    [_nextButton release];
    [super dealloc];
}
@end
