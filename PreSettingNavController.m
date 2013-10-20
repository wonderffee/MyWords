//
//  PreSettingNavController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "PreSettingNavController.h"
#import "PreSetViewController.h"
@interface PreSettingNavController ()

@end

@implementation PreSettingNavController
+ (PreSettingNavController *)sharedPreSettingController
{
    static dispatch_once_t  _singletonPredicate;
    static PreSettingNavController *_thePreSetting = nil;
    dispatch_once(&_singletonPredicate, ^{
        _thePreSetting = [[super allocWithZone:nil]init];
    });
    return _thePreSetting;
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedPreSettingController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _theController = [[PreSetViewController alloc]init];
    
    [self pushViewController:[self theController] animated:YES];
    
    [[self navigationBar] setTintColor:NAV_TINT_COLOR];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_theController release];
    [super dealloc];
}
@end


