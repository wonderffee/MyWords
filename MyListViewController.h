//
//  MyListViewController.h
//  IWords
//
//  Created by yaonphy on 12-11-16.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface MyListViewController : MainViewController< UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
      //数据部分
      NSArray *couponArry;
      NSArray *groupbuyArry;
      
      //页面展示部分
      UITableView *couponTableView;
      UITableView *groupbuyTableView;
      
      //左右滑动部分
	UIPageControl *pageControl;
      int currentPage;
      BOOL pageControlUsed;
}

@property (retain, nonatomic) IBOutlet UIButton *couponButton;
@property (retain, nonatomic) IBOutlet UIButton *groupbuyButton;
@property (retain, nonatomic) IBOutlet UILabel *slidLabel;//用于指示作用
@property (retain, nonatomic) IBOutlet UIScrollView *nibScrollView;

@end
