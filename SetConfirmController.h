//
//  SetConfirmController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NOIMGButton;
@interface SetConfirmController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain) UITableView *showTableView;
@property (retain) NOIMGButton * begainButton;
@property (retain) NSArray *infoStrArr;

@end
