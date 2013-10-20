//
//  PreSetViewController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownList.h"
@class DropDownList;
@interface PreSetViewController : UIViewController <DropDownListDelegate,UITextFieldDelegate>
{
    NSMutableArray *_dropDownListItems;
    id _firstResponder;
}
@property (retain) DropDownList * theDropDownView;
@property (retain) NSArray *libNumbersArr;
@property (retain) NSArray *libNamesArr;
@end
@interface PreSetViewController(Private)
- (void) _initDropDownList;
- (void) _initDropDownListContent;
@end
