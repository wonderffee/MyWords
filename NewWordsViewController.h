//
//  NewWordsViewController.h
//  Iwordsv2
//
//  Created by yaonphy on 12-11-20.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOIMGButton.h"
#import "TBXML.h"
#import "TBXML+Compression.h"
#import "TBXML+HTTP.h"

@interface NewWordsViewController : UIViewController <UIScrollViewDelegate>
@property (retain) NOIMGButton * addToReViewButton;
@property (retain) NOIMGButton * playAudioButton;
@property (retain) UIScrollView * mainScrollView;
@property (assign) NSInteger numPerDay;
@property (assign) NSInteger learnedNum;
@property (retain) NSMutableArray * wordsListArr;
@property (retain) NSMutableArray * wordInfoArr;
@property (assign) NSInteger curIndex;
@property (assign) NSInteger scroIndex;
@property (retain) NOIMGButton * learnedButton;
@property (retain) NSString * prefix;
@property (retain) NSString * suffix;
@property (assign) NSInteger maxMeanNum;
@property (assign) NSInteger maxItemNum;
@property (assign) CGSize meanLabelSize;
@property (assign) CGSize originLabelSize;
@property (assign) CGFloat finalContentHeight;
-(void)loadInitial;
-(void)loadWordsList;
-(void)learnedButtonTouched:(id) sender;
-(void)initMemo;
-(void)traverseElement:(TBXMLElement *)element;
-(void)addToReViewButtonTouched:(id)sender;
-(void)playWordMP3;
-(void)playAudioButtonTouched:(id)sender;
@end
