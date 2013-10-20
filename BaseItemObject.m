//
//  BaseItemObject.m
//  ExtremeMusic
//
//  Created by Nick Marchenko on 14.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseItemObject.h"


@implementation BaseItemObject
@synthesize dataObject = _dataObject;


- (id) init
{
	if (self=[super init])
	{
		_isCurrentlySelected = NO;
	}
	return self;
}

- (void) dealloc
{
	[_dataObject release];
	
	[super dealloc];
}
-(void)setDataObject:(BaseDataObject *)dataObject
{
    if (dataObject) {
        _dataObject = dataObject;
        [dataObject retain];
    }
}
@end
