//
//  LearningViewController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-11-20.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "NOIMGButton.h"
#import "SVProgressHUD.h"
@interface LearningViewController : UIViewController
@property (retain) DACircularProgressView * theCircularProgress;
@property (retain) NOIMGButton * nextButton;
@property (retain) UILabel * percentLabel;
@property (assign) CGFloat curPercent;
@property (retain) UILabel * progressLabel;


-(void)initProThings;
-(void)startAnimation;
-(void)stopAnimation;
-(void)progressChange;
-(void)nextButtontouchedDown:(id)sender;
-(void)nextButtonTouched:(id)sender;
@end
