//
//  NewWordsViewController.m
//  Iwordsv2
//
//  Created by yaonphy on 12-11-20.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "NewWordsViewController.h"

#import "WordInfo.h"
#import "TableDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "AVFoundation/AVFoundation.h"
#ifndef WORD_FT
#define WORD_FT [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]
#endif
#ifndef PRON_FT
#define PRON_FT [UIFont fontWithName:@"HelveticaNeue" size:14.0f]
#endif
#ifndef MEAN_FT 
#define MEAN_FT [UIFont fontWithName:@"HelveticaNeue" size:16.0f]
#endif
NSString *const BaseURLString = @"http://dict-co.iciba.com/api/dictionary.php?w=";

@interface NewWordsViewController ()
{
    
}
@end

@implementation NewWordsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadInitial
{
    UIView * selfView = [self view];
    _wordInfoArr = [[NSMutableArray alloc]init];
    _wordsListArr = [[NSMutableArray alloc]init];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    _numPerDay = [userDefault integerForKey:@"NumPerDay"];
    _learnedNum = [userDefault integerForKey:@"LearnedNum"];
    _maxItemNum = [userDefault integerForKey:@"MaxItemNum"];
    _maxMeanNum = [userDefault integerForKey:@"MaxMeanNum"];
    
    userDefault = nil;
    
    [self loadWordsList];
    
    _prefix = [[NSString alloc]initWithString:@"| "];
    _suffix = [[NSString alloc] initWithString:@" |"];
    _scroIndex = 0;
    
    _addToReViewButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(20, 5, 120, 30) style:NVUIGradientButtonStyleBlackTranslucent];
    [_addToReViewButton setText:@"加入复习计划"];
    [_addToReViewButton setTintColor:NAV_TINT_COLOR forState:UIControlStateHighlighted];
    [_addToReViewButton setBorderColor:MAIN_BG_COLOR forState:UIControlStateNormal];
    [_addToReViewButton setBorderColor:MAIN_BG_COLOR forState:UIControlStateHighlighted];
    [_addToReViewButton addTarget:self action:@selector(addToReViewButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [selfView addSubview:_addToReViewButton];
    
    _playAudioButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(180, 5, 120, 30) style:NVUIGradientButtonStyleBlackTranslucent];
    [_playAudioButton setText:@"播放语音"];
    [_playAudioButton setTintColor:NAV_TINT_COLOR forState:UIControlStateHighlighted];
    [_playAudioButton setBorderColor:MAIN_BG_COLOR forState:UIControlStateNormal];
    [_playAudioButton setBorderColor:MAIN_BG_COLOR forState:UIControlStateHighlighted];
    [_playAudioButton addTarget:self action:@selector(playAudioButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [selfView addSubview:_playAudioButton];
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 320, 340)];
    [_mainScrollView setDelegate:self];
    [_mainScrollView setBackgroundColor:[UIColor whiteColor]];
    [_mainScrollView setPagingEnabled:YES];
    
    int i = 0;
    for (i = 0; i < [[self wordsListArr] count]; i++) {
        @autoreleasepool {
            
            NSString * theURLStr = [BaseURLString stringByAppendingString:[[self wordsListArr] objectAtIndex:i]];
            NSURL * theURL = [[NSURL alloc]initWithString:theURLStr];
            
            NSMutableURLRequest * theRequest = [[NSMutableURLRequest alloc]initWithURL:theURL];
            
            NSData * downLoadData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
            
            theURLStr = nil;
            [theURL release];
            theURL  = nil;
            
            [theRequest release];
            theRequest  = nil;
            
            if (downLoadData) {
                TBXML * theTBXML = [[TBXML alloc]initWithXMLData:downLoadData error:nil];
                
                [self initMemo];
                [self traverseElement:theTBXML.rootXMLElement];
                
                [theTBXML release];
                theTBXML = nil;
                
                UIScrollView * subScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(_curIndex*320, 0,320, 340)];
                
                /*加载解析好的数据....*/
                
                WordInfo * curInfo = [[self wordInfoArr] objectAtIndex:_curIndex];
                
                /*单词和音标....固定*/
                UILabel * wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 320, 30)];
                [wordLabel setFont:WORD_FT];
                if ([curInfo theWord]) {
                    [wordLabel setText:[curInfo theWord]];
                }
                [subScrollView addSubview:wordLabel];
                
                [wordLabel release];
                wordLabel = nil;
                
                UILabel *pronouncelabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 50, 320, 20)];
                [pronouncelabel setFont:PRON_FT];
                if ([[curInfo thePSArr]count]) {
                    NSString * tmpStr = [[self prefix] stringByAppendingString:[[curInfo thePSArr] objectAtIndex:0]];
                    NSString * tmp2Strs = [tmpStr stringByAppendingString:[self suffix]];
                    tmpStr = nil;
                    [pronouncelabel setText:tmp2Strs];
                    tmp2Strs = nil;
                }
                
                [subScrollView addSubview:pronouncelabel];
                [pronouncelabel release];
                pronouncelabel = nil;
                
                /*单词和音标....*/
                
                
                /*词性和对应的释意....*/
                
                NSMutableArray * curPosArr = [curInfo thePosArr];
                NSMutableArray * curAccArr = [curInfo theAcceptationArr];
                
                UILabel * meanLabel = [[UILabel alloc]init];

                if ([curPosArr count] && [curAccArr count]) {
                    
                    NSInteger curItemNum = 0;
                    if (([self maxItemNum] > [curPosArr count])) {
                        curItemNum = [curAccArr count];
                    }else
                    {
                        curItemNum = [self maxItemNum];
                    }
                    NSString * begainStr = [[NSString alloc]initWithString:@""];
                    NSString * finalPoint = nil;
                    for (int i = 0; i < curItemNum; i++) {
                        finalPoint = [begainStr stringByAppendingString:[curPosArr objectAtIndex:i]];
                        finalPoint = [finalPoint stringByAppendingString:@"  "];
                        finalPoint = [finalPoint stringByAppendingString:[curAccArr objectAtIndex:i]];
                        finalPoint = [finalPoint stringByAppendingString:@"\n"];
                        [begainStr release];
                        begainStr = [[NSString alloc]initWithString:finalPoint];
                        finalPoint = nil;
                    }
                    _meanLabelSize = [begainStr sizeWithFont:MEAN_FT constrainedToSize:CGSizeMake(280,960) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    [meanLabel setNumberOfLines:0];
                    [meanLabel setFont:MEAN_FT];
                    [meanLabel setFrame:CGRectMake(20,80,280,_meanLabelSize.height)];
                    
                    [meanLabel setText:begainStr];
                    [begainStr release];
                    begainStr = nil;
                    
                }
                                       
                                       
                [subScrollView addSubview:meanLabel];
                
                [meanLabel release];
                
                
                /*词性和对应的示意....*/
                
                /*例句和对应的示意....*/

                NSMutableArray * curOriArr = [curInfo theOrigArr];
                NSMutableArray * curTraArr = [curInfo theTransArr];
                
                UILabel * originLabel = [[UILabel alloc]init];
                
                if ([curPosArr count] && [curAccArr count]) {
                    
                    NSInteger curMeanNum = 0;
                    
                    if (([self maxMeanNum] > [curOriArr count])) {
                        curMeanNum = [curOriArr count];
                    }else
                    {
                        curMeanNum = [self maxMeanNum];
                    }
                    NSString * begainStr22 = [[NSString alloc]initWithString:@"例句:\n"];
                    NSString * finalPoint22 = nil;
                    for (int i = 0; i < curMeanNum; i++) {
                        finalPoint22 = [begainStr22 stringByAppendingString:[curOriArr objectAtIndex:i]];
                        finalPoint22 = [finalPoint22 stringByAppendingString:@"\n"];
                        finalPoint22 = [finalPoint22 stringByAppendingString:[curTraArr objectAtIndex:i]];
                        finalPoint22 = [finalPoint22 stringByAppendingString:@"\n"];
                        [begainStr22 release];
                        begainStr22 = [[NSString alloc]initWithString:finalPoint22];
                        finalPoint22 = nil;
                    }
                    _originLabelSize = [begainStr22 sizeWithFont:MEAN_FT constrainedToSize:CGSizeMake(280,960) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    [originLabel setNumberOfLines:0];
                    [originLabel setFont:MEAN_FT];
                    [originLabel setFrame:CGRectMake(20,90 + _meanLabelSize.height,280,_originLabelSize.height)];
                    [originLabel setText:begainStr22];
                    [begainStr22 release];
                    begainStr22 = nil;
                    
                }
                
                
                [subScrollView addSubview:originLabel];
                
                [originLabel release];


                /*例句和对应的示意....*/
                
                [subScrollView setShowsVerticalScrollIndicator:YES];
                [subScrollView setShowsHorizontalScrollIndicator:NO];
                _finalContentHeight = 100 + _meanLabelSize.height + _originLabelSize.height;
                [subScrollView setContentSize:CGSizeMake(320, _finalContentHeight)];
                [subScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
                [[self mainScrollView] addSubview:subScrollView];
                
                [subScrollView release];
                subScrollView = nil;
                
            }
            
            downLoadData = nil;
            
        }
    }
    [_mainScrollView setContentSize:CGSizeMake(320*[[self wordsListArr]count], 340)];
    [selfView addSubview:_mainScrollView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self navigationItem] setTitle:@"学习中"];
    [[self view]setBackgroundColor:MAIN_BG_COLOR];
    
    NSUserDefaults * preUserDefault = [NSUserDefaults standardUserDefaults];
    _numPerDay = [preUserDefault integerForKey:@"NumPerDay"];
    _learnedNum = [preUserDefault integerForKey:@"LearnedNum"];
    preUserDefault = nil;
    
    [self loadInitial];
    
}
-(void)learnedButtonTouched:(id) sender
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:[[self wordsListArr] count] + [self numPerDay] forKey:@"LearnedNum"];
}
-(void)initMemo
{
    WordInfo *theInfo = [[WordInfo alloc]init];
    NSMutableArray * thePSArr = [[NSMutableArray alloc]init];
    NSMutableArray * thePronArr = [[NSMutableArray alloc]init];
    NSMutableArray * thePosArr = [[NSMutableArray alloc]init];
    NSMutableArray * theAcceptationArr = [[NSMutableArray alloc]init];
    NSMutableArray * theOrigArr = [[NSMutableArray alloc]init];
    NSMutableArray * theTransArr = [[NSMutableArray alloc]init];
    
    [theInfo setThePSArr:thePSArr];
    [thePSArr release];
    thePSArr = nil;
    
    [theInfo setThePronArr:thePronArr];
    [thePronArr release];
    thePronArr = nil;
    
    [theInfo setThePosArr:thePosArr];
    [thePosArr release];
    thePosArr = nil;
    
    [theInfo setTheAcceptationArr:theAcceptationArr];
    [theAcceptationArr release];
    theAcceptationArr = nil;
    
    [theInfo setTheOrigArr:theOrigArr];
    [theOrigArr release];
    theOrigArr = nil;
    
    [theInfo setTheTransArr:theTransArr];
    [theTransArr release];
    theTransArr = nil;
    
    [[self wordInfoArr]addObject:theInfo];
    [theInfo release];
    theInfo = nil;
    
    NSLog(@"%d\n",[[self wordInfoArr]count]);

    _curIndex = [[self wordInfoArr] count]-1;
    
    
}
/* 解析XML */
- (void) traverseElement:(TBXMLElement *)element {
    
    WordInfo *theInfo = [[self wordInfoArr] objectAtIndex:[self curIndex]];
    
    do {
        // Display the name of the element
//        NSLog(@"%@",[TBXML elementName:element]);
        NSString * elementName = [TBXML elementName:element];
        if ([elementName isEqualToString:@"key"]) {
            NSString * theWord = [[NSString alloc]initWithCString:element->text encoding:NSUTF8StringEncoding];
            if (!theWord) {
                theWord = @"";
            }
            [theInfo setTheWord:theWord];
            [theWord release];
            theWord = nil;
        }
        if ([elementName isEqualToString:@"ps"]) {
            
            NSString * thePS = [[NSString alloc]initWithCString:element->text encoding:NSUTF8StringEncoding];
            if (!thePS) {
                thePS = @"";
            }
            [[theInfo thePSArr] addObject:thePS];
            [thePS release];
            thePS = nil;
        }
        if ([elementName isEqualToString:@"pron"]) {
            NSString * thePron = [[NSString alloc]initWithCString:element->text encoding:NSUTF8StringEncoding];
            if (!thePron) {
                thePron = @"";
            }
            [[theInfo thePronArr] addObject:thePron];
            [thePron release];
            thePron = nil;
        }
        if ([elementName isEqualToString:@"pos"]) {
            NSString * thePos = [[NSString alloc]initWithCString:element->text encoding:NSUTF8StringEncoding];
            if (!thePos) {
                thePos = @"";
            }
            [[theInfo thePosArr] addObject:thePos];
            [thePos release];
            thePos = nil;
        }
        if ([elementName isEqualToString:@"acceptation"]) {
            NSString * theAcception = [[NSString alloc]initWithCString:element->text encoding:NSUTF8StringEncoding];
            if (!theAcception) {
                theAcception = @"";
            }
            [[theInfo theAcceptationArr] addObject:theAcception];
            [theAcception release];
            theAcception = nil;
        }
        if ([elementName isEqualToString:@"orig"]) {
            NSString * theOrig = [[NSString alloc]initWithCString:element->text encoding:NSUTF8StringEncoding];
            if (!theOrig) {
                theOrig = @"";
            }
            [[theInfo theOrigArr] addObject:theOrig];
            [theOrig release];
            theOrig = nil;
        }
        if ([elementName isEqualToString:@"trans"]) {
            if (element) {
                NSString * theTrans = [[NSString alloc]initWithCString:element->text encoding:NSUTF8StringEncoding];
                if (!theTrans) {
                    theTrans = @"";
                }
                [[theInfo theTransArr] addObject:theTrans];
                [theTrans release];
                theTrans = nil;
            }

        }
        
 //       NSLog(@"%s\n",element->text);
        elementName = nil;

        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        // Obtain next sibling element
    } while ((element = element->nextSibling));
    
    theInfo = nil;
    
}
/* 解析XML */
-(void)loadWordsList
{
    @autoreleasepool {
        //对词库分文件的选择没有实现
        NSInteger fileNum = [self learnedNum] / 200;
        NSString * curLibName = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"curLibName"];
        NSString * fileName = [[NSString alloc]initWithFormat:@"%@_%i",curLibName,fileNum];
        
        NSString * sourcePath =  [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        NSDictionary * listDic = [[NSDictionary alloc]initWithContentsOfFile:sourcePath];
        int i = [self learnedNum] + 1;
        int total = [self numPerDay] + [self learnedNum];
        for (; i <= total; i++) {
            NSString * wordsID = [[NSString alloc]initWithFormat:@"%d",i];
            [[self wordsListArr] addObject:[listDic objectForKey:wordsID]];
            [wordsID release];
            wordsID = nil;
        }
        
        [fileName release];
        fileName  = nil;
        
        [listDic release];
        listDic = nil;
    }

}
#pragma UIScrollView Delegate method

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat curOffSetX = self.mainScrollView.contentOffset.x;
    NSInteger nextIndex = (NSInteger)curOffSetX/320;
    [self setScroIndex:nextIndex];
    
    NSLog(@"%i",nextIndex);
    BOOL isAuto = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsAutoPlay"];
    if (isAuto) {
        [self playWordMP3];
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat curOffSetX = self.mainScrollView.contentOffset.x;
    if (curOffSetX > ([[self wordsListArr]count] - 1)*320) {
        
        UIView * doneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 420)];
        [doneView setBackgroundColor:[UIColor whiteColor]];
        
        _learnedButton = [[NOIMGButton alloc]initWithFrame:CGRectMake(20, 160, 260, 40)style:NVUIGradientButtonStyleDefault];
        [_learnedButton addTarget:self action:@selector(learnedButtonTouched:)forControlEvents:UIControlEventTouchUpInside];
        [_learnedButton setText:@"学习完成"];
        
        [doneView addSubview:_learnedButton];
        [[self view] addSubview:doneView];
        [doneView release];
        doneView = nil;
    }
}

#pragma end

-(void)addToReViewButtonTouched:(id)sender
{
    @autoreleasepool {
        
        NSString * theWord = [[[self wordInfoArr]objectAtIndex:[self scroIndex]] theWord];
        NSAssert(theWord, @"无法插入空的单词");
        
        NSString * docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * dbPath = [docStr stringByAppendingPathComponent:@"review.sqlite"];
            
        FMDatabase * theReviewDB = [FMDatabase databaseWithPath:dbPath];
        
        if ([theReviewDB open]) {
            NSString * sql = @"insert into ReviewTable (word) values(?) ";
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
        
        NSInteger reviewNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"reviewTotalNumber"];
        [[NSUserDefaults standardUserDefaults] setInteger:(reviewNum + 1) forKey:@"reviewTotalNumber"];
        
    }
    
    
}
-(void)playWordMP3
{
    if (([[self wordInfoArr]count] - 1) < [self scroIndex]) {
        return;
    }
    NSString * mp3Str =  [[[[self wordInfoArr]objectAtIndex:[self scroIndex]] thePronArr]objectAtIndex:0];
    NSLog(@"%@\n",mp3Str);
    NSURL * mp3Url = [[NSURL alloc]initWithString:mp3Str];
    mp3Str = nil;
    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:mp3Url error:nil];
    if (avPlayer) {
        [avPlayer play];
    }
    [mp3Url release];
    [avPlayer release];
}
-(void)playAudioButtonTouched:(id)sender
{
    [self playWordMP3];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_prefix release];
    [_suffix release];
    [_wordInfoArr release];
    [_wordsListArr release];
    [_addToReViewButton release];
    [_playAudioButton release];
    [_mainScrollView release];
    [_learnedButton release];
    [super dealloc];
}
@end
