//
//  MainViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-11-3.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "MainViewController.h"
#import "RootNavViewController.h"
#import "SettingViewController.h"
#import "NOIMGButton.h"
#import "LearningViewController.h"
#import "ReviewProViewController.h"

#define BT_HI_COLOR   [UIColor colorWithRed:49.0f/RGB_MAX green:41.0f /RGB_MAX blue:171.0f/RGB_MAX alpha:1.0f]
@interface MainViewController ()
{
    SettingViewController *_theSettingController;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initNavItem
{
    [[self view] setBackgroundColor:MAIN_BG_COLOR];
    /**************左边NAVItem************/
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"学习助手" style:UIBarButtonItemStyleBordered target:[self navigationController] action:@selector(toggleMenu)];
    [[self navigationItem]setLeftBarButtonItem:leftBarButton];
    [leftBarButton release];
    leftBarButton = nil;
    
    /**************左边NAVItem************/
    
    /**************右边NAVItem************/
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"设   置" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemTouched:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
    rightBarButton = nil;
    /**************右边NAVItem************/
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        self.title = @"iWords";

    [self initNavItem];
    
    NOIMGButton * learnButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(40, 40, 80, 80) style:NVUIGradientButtonStyleDefault];
    [learnButton setText:@"开始学习"];
    [learnButton setBorderColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [learnButton setTintColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [learnButton setTintColor:BT_HI_COLOR forState:UIControlStateHighlighted];
    [learnButton setBorderColor:BT_HI_COLOR forState:UIControlStateHighlighted];

    [learnButton addTarget:self action:@selector(learnbuttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NOIMGButton * reviewButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(200, 40, 80, 80) style:NVUIGradientButtonStyleDefault];
    [reviewButton setText:@"开始复习"];
    [reviewButton setBorderColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [reviewButton setTintColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [reviewButton setTintColor:BT_HI_COLOR forState:UIControlStateHighlighted];
    [reviewButton setBorderColor:BT_HI_COLOR forState:UIControlStateHighlighted];
    [reviewButton addTarget:self action:@selector(reviewButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

    
    NOIMGButton * testButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(40, 160, 80, 80) style:NVUIGradientButtonStyleDefault];
    [testButton setText:@"开始测试"];
    [testButton setBorderColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [testButton setTintColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [testButton setTintColor:BT_HI_COLOR forState:UIControlStateHighlighted];
    [testButton setBorderColor:BT_HI_COLOR forState:UIControlStateHighlighted];
    
    NOIMGButton * correctionButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(200, 160, 80, 80) style:NVUIGradientButtonStyleDefault];
    [correctionButton setText:@"攻克错词"];
    [correctionButton setBorderColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [correctionButton setTintColor:NAV_TINT_COLOR forState:UIControlStateNormal];
    [correctionButton setTintColor:BT_HI_COLOR forState:UIControlStateHighlighted];
    [correctionButton setBorderColor:BT_HI_COLOR forState:UIControlStateHighlighted];
    
    UIView *selfView = [self view];
    [selfView addSubview:learnButton];
    [selfView addSubview:reviewButton];
    [selfView addSubview:testButton];
    [selfView addSubview:correctionButton];
    
    [learnButton release];
    learnButton = nil;
    [reviewButton release];
    reviewButton  = nil;
    [testButton release];
    testButton = nil;
    [correctionButton release];
    correctionButton = nil;
}
-(void)learnbuttonTouched:(id) sender
{
    LearningViewController *theController = [[LearningViewController alloc]init];
    [[self navigationController]pushViewController:theController animated:YES];
    [theController release];
    theController = nil;
    
}
-(void)reviewButtonTouched:(id) sender
{
    ReviewProViewController * theController = [[ReviewProViewController alloc]init];
    [[self navigationController] pushViewController:theController animated:YES];
    [theController release];
    theController = nil;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    RootNavViewController *navigationController = (RootNavViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}
-(void)rightBarButtonItemTouched:(id)sender
{
    _theSettingController = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:_theSettingController animated:YES];
    [_theSettingController release];
    _theSettingController = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
