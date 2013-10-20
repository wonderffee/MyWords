//
//  WordInfo.h
//  Iwordsv2
//
//  Created by yaonphy on 12-11-13.
//  Copyright (c) 2012年 yang. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface WordInfo : NSObject
/*
    数据说明：theWord 单词
             thePS   音标数组
             thePron 语音MP3文件的网址数组
             thePosArr 词性数组
             theAcceptationArr 单词释意数组
             theOrigArr 例句数组
             theTransArr 例句释意数组
 
 */
@property (retain) NSString * theWord;
@property (retain) NSMutableArray * thePSArr;
@property (retain) NSMutableArray * thePronArr;
@property (retain) NSMutableArray * thePosArr;
@property (retain) NSMutableArray * theAcceptationArr;
@property (retain) NSMutableArray * theOrigArr;
@property (retain) NSMutableArray * theTransArr;
@end
