//
//  SettingViewController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-11-18.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (retain) UITableView *theTableview;
@property (retain) NSMutableDictionary *theDataDic;
@property (retain) NSMutableArray *theDataArr;
@end
