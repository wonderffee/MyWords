//
//  TableDelegate.h
//  Iwordsv2
//
//  Created by yaonphy on 12-11-11.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordInfo.h"

@interface TableDelegate : NSObject <NSObject,UITableViewDataSource,UITableViewDelegate>
@property (retain) WordInfo * theWordInfo;
@end
