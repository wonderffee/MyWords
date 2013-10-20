//
//  PreSettingNavController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PreSettingNavController : UINavigationController
{

}
@property (retain) UIViewController * theController;
+ (PreSettingNavController *)sharedPreSettingController;
@end


