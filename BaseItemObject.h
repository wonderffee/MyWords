//
//  BaseItemObject.h
//  ExtremeMusic
//
//  Created by Nick Marchenko on 14.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseDataObject;

@interface BaseItemObject : NSObject {

}


@property (nonatomic, retain) BaseDataObject	*dataObject;
@property (nonatomic, assign) BOOL				isCurrentlySelected;


@end
