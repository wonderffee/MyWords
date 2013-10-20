//
//  RootNavViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-11-13.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "RootNavViewController.h"
#import "MainViewController.h"
#import "MyListViewController.h"
#import "CalendarViewController.h"
#import "HomeViewController.h"
@interface RootNavViewController ()
{
    
}
@end

@implementation RootNavViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [_menu dealloc];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self navigationBar] setTintColor:NAV_TINT_COLOR];
    [[self view] setFrame:CGRectMake(0, 0, 320, 420)];
    
    __typeof (&*self) __unsafe_unretained weakSelf = self;
    
    REMenuItem *homeItem = [[REMenuItem alloc]
                             initWithTitle:@"iWords"
                             subtitle:@"首页面"
                             image:[UIImage imageNamed:@"Icon_Home"]
                             highlightedImage:nil
                             action:^(REMenuItem *item) {
                                 NSLog(@"Item: %@", item);
                                HomeViewController *mainController = [HomeViewController alloc];
                                 [weakSelf setViewControllers:@[mainController] animated:NO];
                                 [mainController release];
                                 mainController = nil;
                             }];

    
    REMenuItem *wordsItem = [[REMenuItem alloc]
                             initWithTitle:@"单词本"
                             subtitle:@"记录需要复习的词以及错词"
                             image:[UIImage imageNamed:@"Icon_Home"]
                             highlightedImage:nil
                             action:^(REMenuItem *item) {
                                 NSLog(@"Item: %@", item);
                                 MyListViewController *theController = [[MyListViewController alloc] init];
                                 [weakSelf setViewControllers:@[theController] animated:NO];
                                 [theController release];
                                 theController = nil;
                             }];
    
    
    REMenuItem *calendarItem = [[REMenuItem alloc]
                                initWithTitle:@"学习日历"
                                subtitle:@"查看自己的学习的点点滴滴"
                                image:[UIImage imageNamed:@"Icon_Explore"]
                                highlightedImage:nil
                                action:^(REMenuItem *item) {
                                    NSLog(@"Item: %@", item);
                                    CalendarViewController *theController = [[CalendarViewController alloc] init];
                                    [weakSelf setViewControllers:@[theController] animated:NO];
                                    [theController release];
                                    theController = nil;
                                }];
    [homeItem setTag:0];
    [wordsItem setTag:1];
    [calendarItem setTag:2];
    
    _menu = [[REMenu alloc] initWithItems:@[homeItem,wordsItem,calendarItem]];
    [_menu setBackgroundColor:NAV_TINT_COLOR];
    _menu.cornerRadius = 4;
    _menu.shadowRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    _menu.waitUntilAnimationIsComplete = NO;
    
    weakSelf = nil;
}
- (void)toggleMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    [_menu showFromNavigationController:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
