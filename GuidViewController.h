//
//  GuidViewController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidViewController : UIViewController
{
    BOOL _animating;
    
    UIScrollView *_pageScroll;
}
@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIScrollView *pageScroll;

+ (GuidViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
