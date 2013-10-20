//
//  SetConfirmController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.


#import "SetConfirmController.h"
#import "NOIMGButton.h"
#import "RootNavViewController.h"
#import "MainViewController.h"
#import "PreSettingNavController.h"
#define SHOW_ROW 6
#define ROW_HEIHGT 50.0f
#define ROW_BG_COLOR   [UIColor colorWithRed:27.0f/RGB_MAX green:24.0f/RGB_MAX blue:24.0f/RGB_MAX alpha:0.8]
#define ROW_BORDER_COLOR     [UIColor darkGrayColor]
#define CELL_FONT  [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.00]
@interface SetConfirmController ()
{
    NSUserDefaults * _theDefault;
}
@end

@implementation SetConfirmController

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
    [[self navigationItem] setTitle:@"确认计划"];
    
    _showTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width,SHOW_ROW * ROW_HEIHGT) style:UITableViewStylePlain];
    _begainButton  = [[NOIMGButton alloc]initWithFrame:CGRectMake(32, SHOW_ROW*ROW_HEIHGT+50,256,40) style:NVUIGradientButtonStyleBlackOpaque];
    
    
    _theDefault = [NSUserDefaults standardUserDefaults];
    NSString *plstPath = [[NSBundle mainBundle] pathForResource:@"ConfirmStr" ofType:@"plist"];
    _infoStrArr = [[NSArray alloc]initWithContentsOfFile:plstPath];
    
    UITableView * theTableView = [self showTableView];
    NOIMGButton * theButton = [self begainButton];
    UIView * theView = [self view];
    

    [theButton setText:@"确认设置"];
    [theButton addTarget:self action:@selector(nextButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [theTableView setDelegate:self];
    [theTableView setDataSource:self];
    [theTableView setBounces:NO];
    [theTableView setShowsHorizontalScrollIndicator:NO];
    [theTableView setShowsVerticalScrollIndicator:NO];
    [theTableView setRowHeight:ROW_HEIHGT];
//    [theTableView setBackgroundColor:ROW_BG_COLOR];
    [theTableView setSeparatorColor:ROW_BORDER_COLOR];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [theView addSubview:theTableView];
    [theView addSubview:theButton];
    
    theView = nil;
    theTableView = nil;
    theButton = nil;

}
- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}
-(void)nextButtonTouched:(UIButton *)sender
{
    if ( [[[self navigationController]class] isSubclassOfClass:[PreSettingNavController class]]) {
        MainViewController *mainController = [[MainViewController alloc]init];
        RootNavViewController * rootNav = [[RootNavViewController alloc]initWithRootViewController:mainController];
        [[self mainWindow] setRootViewController:rootNav];
        
        UINavigationController * pareNav  = [self navigationController];
        [pareNav popViewControllerAnimated:NO];
        [pareNav popViewControllerAnimated:NO];
        [pareNav release];
        
        [mainController release];
        mainController = nil;
        [rootNav release];
        rootNav = nil;
        NSLog(@"第一次");
    }else
    {
        [[self navigationController] popToRootViewControllerAnimated:YES];
        NSLog(@"非第一次");
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    _theDefault = nil;
    [_infoStrArr release];
    [_begainButton release];
    [_showTableView release];
    [super dealloc];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SHOW_ROW;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    NSString * theText = [[_infoStrArr objectAtIndex:indexPath.row]copy];
    NSString * numStr = nil;
    switch (indexPath.row) {
        case 0:
            numStr = [[NSString alloc]initWithString:[_theDefault valueForKey:@"curLibName"]];
            break;
        case 1:
            numStr = [[NSString alloc]initWithFormat:@"%d",[_theDefault integerForKey:@"NumPerDay"]];
            break;
        case 2:
            numStr = [[NSString alloc]initWithFormat:@"%d",[_theDefault integerForKey:@"ReNumPreDay"]];
            break;
        case 3:
            numStr = [[NSString alloc]initWithFormat:@"%d",[_theDefault integerForKey:@"MaxMeanNum"]];
            break;
        case 4:
            numStr = [[NSString alloc]initWithFormat:@"%d",[_theDefault integerForKey:@"MaxItemNum"]];
            break;
        case 5:
            if ([_theDefault boolForKey:@"IsAutoPlay"]) {
                numStr = @"  是";
            }else
            {
                numStr = @"  否";
            }
            break;
        default:
            return cell;
    }
    //如下做法，theText 又指向一个autorelease的新的内存，之前所指向的内存貌似没有释放。
    //theText = [theText stringByAppendingString:numStr];
    NSString *poitStr = [theText stringByAppendingString:numStr];
    [[cell textLabel] setFont:CELL_FONT];
    [[cell textLabel] setText:poitStr];
    
    [numStr release];
    [theText release];
    poitStr = nil;
    return  cell;
}
@end
