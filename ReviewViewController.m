//
//  ReviewViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-11-20.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "ReviewViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadWordsList
{
    NSUserDefaults *thisDef = [NSUserDefaults standardUserDefaults];
    
    [self setNumPerDay:[thisDef integerForKey:@"ReNumPreDay"]];
    [self setLearnedNum:[thisDef integerForKey:@"ReviewedNum"]];
    
     @autoreleasepool {
     
         NSString * docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         NSString * dbPath = [docStr stringByAppendingPathComponent:@"review.sqlite"];
         
         FMDatabase * theReviewDB = [FMDatabase databaseWithPath:dbPath];
         NSInteger reviewSum = [[NSUserDefaults standardUserDefaults] integerForKey:@"reviewTotalNumber"];
         int fromNum = [self learnedNum] + 1;
         int toNum = 0;
         if ([self learnedNum] + [self numPerDay] > reviewSum) {
             toNum = reviewSum;
         }else
         {
             toNum = [self learnedNum] + [self numPerDay];
         }
         if ([theReviewDB open]) {
             NSString * sqlMent = [[NSString alloc]initWithFormat:@" select * from ReviewTable where id between %i and %i",fromNum,toNum];
             FMResultSet * rs = [theReviewDB executeQuery:sqlMent];
             NSLog(@"%p\n",rs);
             while ([rs next]) {
                 int userId = [rs intForColumn:@"id"];
                 NSString * thisWord = [rs stringForColumn:@"word"];
                 [[self wordsListArr] addObject:thisWord];
                 NSLog(@"user id = %d, word = %@\n", userId,thisWord);
             }
             [theReviewDB close];
             
             [sqlMent release];
             sqlMent = nil;
     
         }
 
         docStr = nil;
         dbPath = nil;
 
     }
}

- (void)viewDidLoad
{
//    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self navigationItem] setTitle:@"复习中"];
    [[self view]setBackgroundColor:MAIN_BG_COLOR];
        
    [self loadInitial];
    
    [[self addToReViewButton]setText:@"加入单词本"];
    [[self learnedButton]setText:@"完成复习"];

    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat curOffSetX = self.mainScrollView.contentOffset.x;
    if (curOffSetX > ([[self wordsListArr]count] - 1)*320) {
        
        UIView * doneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 420)];
        [doneView setBackgroundColor:[UIColor whiteColor]];
        
        NOIMGButton * learnedButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(20, 160, 260, 40)style:NVUIGradientButtonStyleDefault];
        [learnedButton addTarget:self action:@selector(learnedButtonTouched:)forControlEvents:UIControlEventTouchUpInside];
        [learnedButton setText:@"复习完成"];
        
        [doneView addSubview:learnedButton];
        [learnedButton release];
        learnedButton = nil;
        [[self view] addSubview:doneView];
        [doneView release];
        doneView = nil;
    }
}
-(void)learnedButtonTouched:(id) sender
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:[[self wordsListArr] count] + [self learnedNum] forKey:@"ReviewedNum"];
}
-(void)addToReViewButtonTouched:(id)sender
{
    @autoreleasepool {
        
        NSString * theWord = [[self wordsListArr]objectAtIndex:[self scroIndex]];
        NSAssert(theWord, @"无法插入空的单词");
        
        NSString * docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * dbPath = [docStr stringByAppendingPathComponent:@"review.sqlite"];
        
        FMDatabase * theReviewDB = [FMDatabase databaseWithPath:dbPath];
        
        if ([theReviewDB open]) {
            NSString * sql = @"insert into VocabTable (word) values(?) ";
            BOOL res = [theReviewDB executeUpdate:sql,theWord];
            if (!res) {
                NSLog(@"error to insert data");
            } else {
                NSLog(@"succ to insert data");
            }
            [theReviewDB close];
        }
        
        docStr = nil;
        dbPath = nil;
        theWord = nil;
        
        NSInteger reviewNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"vocabTotalNumber"];
        [[NSUserDefaults standardUserDefaults] setInteger:(reviewNum + 1) forKey:@"vocabTotalNumber"];
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
