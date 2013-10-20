//
//  RootNavViewController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-11-13.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"
@interface RootNavViewController : UINavigationController
@property (strong, readonly, nonatomic) REMenu *menu;
- (void)toggleMenu;
@end
