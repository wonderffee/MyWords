//
//  TableDelegate.m
//  Iwordsv2
//
//  Created by yaonphy on 12-11-11.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "TableDelegate.h"

@implementation TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TB_ROW_NUM;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"TheCell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell  = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
//    NSLog(@"%@\n",[[self theWordInfo]theWord]);
//    [[cell textLabel]setText:[[self theWordInfo] theWord]];
    [[cell textLabel] setText:@"dfsaaaaa"];
    
    return cell;
}
-(void)dealloc
{
    [_theWordInfo release];
    [super dealloc];
}
@end
