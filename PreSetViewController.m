//
//  PreSetViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-10-28.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "PreSetViewController.h"
#import "NOIMGButton.h"
#import "DropDownList.h"
#import "Configuration.h"
#import "BaseDataObject.h"
#import "SLGlowingTextField.h"
#import "SetConfirmController.h"
#ifndef SET_ROW_NUM
#define SET_ROW_NUM 6
#endif
#ifndef TAG_BASE
#define TAG_BASE 1000
#endif

@interface PreSetViewController ()

@end

@implementation PreSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initializeSetting
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:30 forKey:@"NumPerDay"];
    [userDefault setInteger:30 forKey:@"ReNumPreDay"];
    [userDefault setInteger:2 forKey:@"MaxMeanNum"];
    [userDefault setInteger:2 forKey:@"MaxItemNum"];
    [userDefault synchronize];
    userDefault = nil;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _dropDownListItems = [[NSMutableArray alloc]init];
    
    NSString * libNamesPath = [[NSBundle mainBundle] pathForResource:@"LibNames" ofType:@"plist"];
    NSString * libNumPath = [[NSBundle mainBundle] pathForResource:@"LibNumbers" ofType:@"plist"];
    
    _libNamesArr = [[NSArray alloc]initWithContentsOfFile:libNamesPath];
    _libNumbersArr = [[NSArray alloc]initWithContentsOfFile:libNumPath];
    
    /*********************navigationBar/Item 设置**********************/
    [[self navigationItem] setTitle:@"敲定计划"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemTouched:)];
    [[self navigationItem] setRightBarButtonItem:rightItem];
    [rightItem release];
    rightItem = nil;
    /*********************navigationBar/Item 设置**********************/
    
    /*********************初始化默认设置**********************/
    [self initializeSetting];
    /*********************初始化默认设置**********************/
    /*********************选择词库的DropDownView 创建、初始化**********************/
    
    [self _initDropDownList];
    [self _initDropDownListContent];
    
    DropDownList * curDropDown = [self theDropDownView];
    [curDropDown setDelegate:self];
    [curDropDown setObjects:_dropDownListItems];
    [_dropDownListItems release];
    _dropDownListItems = nil;
    [curDropDown setUserInteractionEnabled:YES];
    [[self view] addSubview:curDropDown];
    
    curDropDown = nil;
    /*********************选择词库的DropDownView 创建、初始化**********************/
    
    /*******************其它预设置初始化**************************/
    NSString * labelTextPath = [[NSBundle mainBundle] pathForResource:@"SettingLableText" ofType:@"plist"];
    NSString * holderPath = [[NSBundle mainBundle] pathForResource:@"HolderString" ofType:@"plist"];
    NSArray *labelTextArr = [[NSArray alloc]initWithContentsOfFile:labelTextPath];
    NSArray *holderArr = [[NSArray alloc]initWithContentsOfFile:holderPath];
    int i = 0;
    for (i = 1; i < SET_ROW_NUM - 1; i++) {
        CGRect theFrame = CGRectMake(32,i * 70, 256, 70);
        UIView * theView = [[UIView alloc]initWithFrame:theFrame];
        
        UILabel *introLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, theFrame.size.width, theFrame.size.height/2-4)];
        SLGlowingTextField *glowText = [[SLGlowingTextField alloc]initWithFrame:CGRectMake(0, theFrame.size.height/2+2, theFrame.size.width, theFrame.size.height/2-4)];
        
        [introLable setText:[labelTextArr objectAtIndex:i-1]];
        [introLable setTextAlignment:NSTextAlignmentLeft];
        [introLable setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        
        [glowText setPlaceholder:[holderArr objectAtIndex:i-1]];
        [glowText setTag:TAG_BASE+i];
        [glowText setDelegate:self];
        [glowText setKeyboardType:UIKeyboardTypeNumberPad];
        [glowText setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [glowText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [glowText setTextAlignment:NSTextAlignmentCenter];
        [theView addSubview:introLable];
        [theView addSubview:glowText];
        [introLable release];
        [glowText release];
        
        [[self view] addSubview:theView];
        [theView release];
    }
    
    [labelTextArr release];
    [holderArr release];
    
    /*******************其它预设置初始化**************************/
    /*******************是否默认自动播放语音**************************/
    UILabel *switchLable = [[UILabel alloc]initWithFrame:CGRectMake(32, (SET_ROW_NUM-1) * 70+10, 150, 50)];
    [switchLable setText:@"是否自动播放语音"];
    [switchLable setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    
    UISwitch * theSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(170, (SET_ROW_NUM-1) * 70+20, 0, 50)];
    [theSwitch setTintColor:[UIColor blackColor]];
    [theSwitch setSelected:NO];
    [[self view]addSubview:switchLable];
    [[self view]addSubview:theSwitch];
    [switchLable release];
    switchLable = nil;
    [theSwitch release];
    theSwitch = nil;
    /*******************是否默认自动播放语音**************************/


}
-(void)rightItemTouched:(id) sender
{
    BOOL isAuto = [[[[self view]subviews]lastObject] isSelected];
    [[NSUserDefaults standardUserDefaults] setBool:isAuto forKey:@"IsAutoPlay"];
    SetConfirmController * confirmController = [[SetConfirmController alloc]init];
    [[self navigationController] pushViewController:confirmController animated:YES];
    [confirmController release];
    confirmController = nil;
    
}
#pragma mark DropDownList delegate
- (void) dropDownListItemDidSelected:(DropDownList*) theDropDownList WithNumber:(int) k
{
    //	NSLog(@"item number: %i was selected in dropdownlist with name: %@", k + 1, theDropDownList.name);
    NSInteger curNum = [[[self libNumbersArr] objectAtIndex:k] integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:curNum forKey:@"curTotalNumber"];
    [[NSUserDefaults standardUserDefaults] setValue:[[self libNamesArr]objectAtIndex:k] forKey:@"curLibName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //当前已经学习的单词数设置为零
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LearnedNum"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ReviewedNum"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"reviewTotalNumber"];
    
    //    NSLog(@"%d\n",[[NSUserDefaults standardUserDefaults] integerForKey:@"curTotalNumber"]);
}

- (void) dropDownListDidShown:(DropDownList*) theDropDownList
{
	//NSLog(@"dropdownlist is shown");
}
#pragma mark end
/**************键盘收回以及view的位置恢复************/

#pragma mark DropDownList delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect curFrame = [[self view]frame];
    curFrame.origin.y = 0.0f;
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
    [UIView transitionWithView:self.view duration:0.5 options:options animations:^{
        self.view.frame = curFrame;
    } completion:^(BOOL finished){
        if (!finished) {
            NSLog(@"animation was failed!");
        }
    }];
    
    if (_firstResponder) {
        [_firstResponder resignFirstResponder];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view ]endEditing:NO];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger curTag = [textField tag];
    CGRect transtoFrame = [[self view]frame];
    switch (curTag) {
        case TAG_BASE + 2:
            transtoFrame.origin.y -= 20;
            break;
        case TAG_BASE + 3:
            transtoFrame.origin.y -= 90;
            break;
        case TAG_BASE + 4:
            transtoFrame.origin.y -= 160;
            break;
        default:
            return;
    }
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
    [UIView transitionWithView:self.view duration:0.5 options:options animations:^{
        self.view.frame = transtoFrame;
    } completion:^(BOOL finished){
        if (!finished) {
            NSLog(@"animation was failed!");
        }
    }];
    
    _firstResponder = textField;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger curTag = [textField tag];
    NSInteger textIntValue = [[textField text]integerValue];
    NSUserDefaults * theDefault = [NSUserDefaults standardUserDefaults];
    switch (curTag) {
        case TAG_BASE + 1:
            [theDefault setInteger:textIntValue forKey:@"NumPerDay"];
            break;
        case TAG_BASE + 2:
            [theDefault setInteger:textIntValue forKey:@"ReNumPreDay"];
            break;
        case TAG_BASE + 3:
            [theDefault setInteger:textIntValue forKey:@"MaxMeanNum"];
            break;
        case TAG_BASE + 4:
            [theDefault setInteger:textIntValue forKey:@"MaxItemNum"];
            break;
        default:
            return;
    }
    [theDefault synchronize];
    theDefault = nil;
}
#pragma mark end
-(void)dealloc
{
    _firstResponder = nil;
    [_libNamesArr release];
    [_libNumbersArr release];
    [_theDropDownView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation PreSetViewController(Private)
// myDropDownList button possition in MainViewController
#define MY_DROPDOWNLIST_ORIGIN									CGPointMake(32.0f,15.0f)

// myDropDownList name to use in delegate methods
#define MY_DROPDOWNLIST_NAME									@"请选择学习的词库类别"

// myDropDownList type to use in
// + (void) _pasteData:(DOBaseDropDownCellObject*)_data To:(id)_destination WithType:(NSString*) type
// methos
#define MY_DROPDOWNLIST_TYPE									@"DEFAULT_TYPE"

// Number of items to display in myDropDownList
#define	ITEMS_NUMBER											6

// Instruction label frame in button
#ifndef BUTTON_INSTRUCTION_LABEL_FRAME
#define BUTTON_INSTRUCTION_LABEL_FRAME							CGRectMake(14.0,5.0,200.0,20.0)
#endif
// myDropdownList table view parameters
static const CGFloat X_TABLE_MARGIN								= 4.0;
static const CGFloat Y_TABLE_MARGIN								= 45.0;

// myDropDownList backgroud parameters
static const CGFloat X_BAKCGROUND_MARGIN						= -13.0;
static const CGFloat Y_BACKGROUND_MARGIN						= 0.0;
static const CGFloat BG_UNDER_TABLE_HEIGHT						= 20.0;
- (void) _initDropDownList
{
	// Create configuration object
	Configuration *config = [[[Configuration alloc] init] autorelease];
	
	_theDropDownView = [[DropDownList alloc] initWithOrigin:MY_DROPDOWNLIST_ORIGIN
                                              ActiveImage:config.buttonActiveBG
                                        WithInactiveImage:config.buttonNoActiveBG];
    DropDownList * curDropDown = [self theDropDownView];
	
	curDropDown.name = MY_DROPDOWNLIST_NAME;
	curDropDown.type = MY_DROPDOWNLIST_TYPE;
	curDropDown.buttonInstructionLabelFrame = BUTTON_INSTRUCTION_LABEL_FRAME;
	
	[curDropDown setTopMainBG:config.openBGTop setMiddleBG:config.openBGMiddle setBottom:config.openBGBottom];
	
	[curDropDown setCellBGImage:config.itemBG setCellBGHoverImage:config.itemBGHoved];
	
	[curDropDown setBGXMargin:X_BAKCGROUND_MARGIN
                    BGYMargin:Y_BACKGROUND_MARGIN
           BGUnderTableHeight:BG_UNDER_TABLE_HEIGHT];
	
	[curDropDown setTableXMargin:X_TABLE_MARGIN TableYMargin:Y_TABLE_MARGIN];
	
	curDropDown.cellDispAmount = ITEMS_NUMBER;
	
	// Make myDropDownList inactive by default
	[curDropDown setUserInteractionEnabled:NO];
	
	// Set parent view controller
	curDropDown.parentViewController = self;
    
    curDropDown = nil;
}
- (void) _initDropDownListContent
{
	int itemsNumber = 0;
    
    //    NSLog(@"%@",libNamesArr);
    itemsNumber = [[self libNumbersArr] count];
	for (int i = 0; i < itemsNumber; i++)
	{
		BaseItemObject *tempBaseItemObject = [[BaseItemObject alloc] init];
		BaseDataObject *tempBaseDataObject = [[BaseDataObject alloc] init];
        NSString * libNameStr = [[NSString alloc]initWithString:[[self libNamesArr] objectAtIndex:i]];
        [tempBaseDataObject setName:libNameStr];
        [libNameStr release];
        libNameStr = nil;
        
        int theTotalNum = [[[self libNumbersArr] objectAtIndex:i] integerValue];
        NSString * libNumberStr = [[NSString alloc]initWithFormat:@"一共需要学习 %d 个单词",theTotalNum];
        [tempBaseDataObject setDescription:libNumberStr];
        [libNumberStr release];
        libNumberStr = nil;
        
		tempBaseDataObject.image = [UIImage imageNamed:@"icon.png"];
        [tempBaseItemObject setDataObject:tempBaseDataObject];
        [tempBaseDataObject release];
        tempBaseDataObject = nil;
        
		[_dropDownListItems addObject:tempBaseItemObject];
        
        [tempBaseItemObject release];
        tempBaseItemObject = nil;
	}
}

@end



