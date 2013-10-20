//
//  SettingViewController.m
//  IWords
//
//  Created by yaonphy on 12-11-18.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "SettingViewController.h"
#import "PreSetViewController.h"
#import "RemindViewController.h"
#import "DownLoadViewController.h"
#import "HelpViewController.h"
#import "ScoreViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#define SET_CELL_FONT  [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.00]

@interface SettingViewController ()
{

}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [_theDataArr release];
    [_theDataDic release];
    [_theTableview release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self view]setBackgroundColor:MAIN_BG_COLOR];
    self.title = @"设置";
    [self initializedData];
    [self initializedTableView];
    [self.view addSubview:_theTableview];
    
    
}
-(void)initializedData
{
    NSString * sourcePath = [[NSBundle mainBundle] pathForResource:@"SettingDic" ofType:@"plist"];
    _theDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:sourcePath];
//    NSLog(@"%@",_theDataDic);
    
    _theDataArr = [[NSMutableArray alloc]initWithArray:[_theDataDic allKeys]];
    
}
-(void)initializedTableView
{
    _theTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    /* iOS 6 之后模拟器中，Group 类型UITableView 背景颜色设置问题*/
    [_theTableview setBackgroundView:nil];
    [_theTableview setBackgroundColor:[UIColor clearColor]];
    
    _theTableview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _theTableview.delegate = self;
    [[_theTableview backgroundView] setBackgroundColor:[UIColor clearColor]];
    _theTableview.dataSource = self;
    [_theTableview setSeparatorColor:[UIColor darkGrayColor]];
    [_theTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self theDataDic] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  
    return [[self theDataArr] objectAtIndex:section];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self theDataDic] objectForKey:[[self theDataArr] objectAtIndex:section]] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"TheCell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell  = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray * curDataArr = [[self theDataDic] valueForKey:[[self theDataArr] objectAtIndex:indexPath.section]];
    [[cell textLabel] setFont:SET_CELL_FONT];
    [cell.textLabel setText:[curDataArr objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *theController;
    if (indexPath.section == 0) {
        theController = [[DownLoadViewController alloc]init];
        [self pushDetailViewController:theController];
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                theController = [[PreSetViewController alloc]init];;
                [self pushDetailViewController:theController];
                break;
            case 1:
                theController = [[RemindViewController alloc]init];
                [self pushDetailViewController:theController];
                break;
            default:
                return;
        }
    }
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                theController = [[HelpViewController alloc]init];
                [self pushDetailViewController:theController];
                break;
            case 1:
                theController = [[FeedbackViewController alloc]init];
                [self pushDetailViewController:theController];
                break;
            case 2:
                theController = [[ScoreViewController alloc]init];
                [self pushDetailViewController:theController];
                break;
            case 3:
                theController = [[AboutViewController alloc]init];
                [self pushDetailViewController:theController];
                break;
                
            default:
                return;
        }
    }
    /* theController 在 pushDetailViewController: 方法中 rlease*/
}
-(void)pushDetailViewController:(UIViewController *)theController
{
    [self.navigationController pushViewController:theController animated:YES];
    [theController release];
}
@end
