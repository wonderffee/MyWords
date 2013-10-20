//
//  ReviewProViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-11-20.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "ReviewProViewController.h"
#import "ReviewViewController.h"
@interface ReviewProViewController ()

@end

@implementation ReviewProViewController

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
    
    [[self navigationItem] setTitle:@"复习词汇"];
    [[self view] setBackgroundColor:MAIN_BG_COLOR];
    
    [self initProThings];

    NSInteger totalNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"reviewTotalNumber"];
    NSInteger reviewedNum = [[NSUserDefaults standardUserDefaults]integerForKey:@"ReviewedNum"];
    [self setCurPercent:(CGFloat)reviewedNum / (CGFloat)totalNum];
    
    NSString * perStr = [[NSString alloc]initWithFormat:@"%.4f%c",[self curPercent]*100,'%'];
    [[self percentLabel] setText:perStr];
    [perStr release];
    perStr = nil;

    
    NSString * progressStr = [[NSString alloc]initWithFormat:@"学习进度：%i%c%i",reviewedNum,'/',totalNum];
    [[self progressLabel] setText:progressStr];
    [progressStr release];
    progressStr = nil;
    
    [[self nextButton] setText:@"开始复习"];
    
    [self startAnimation];
    
}
-(void)nextButtonTouched:(id)sender
{
    NSInteger totalNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"reviewTotalNumber"];
    NSInteger reviewedNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"ReviewedNum"];
    if (!totalNum) {
        [SVProgressHUD dismiss];
        UIAlertView * curAlerView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"复习库为空" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [curAlerView show];
        return;
    }
    if (totalNum <= reviewedNum) {
        [SVProgressHUD dismiss];
        UIAlertView * curAlerView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"全部复习完了，再学习新词吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [curAlerView show];
        return;
    }
    ReviewViewController *theNew = [[ReviewViewController alloc]init];
    [[self navigationController] pushViewController:theNew animated:YES];
    [theNew release];
    theNew = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD dismiss];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
