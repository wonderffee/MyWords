//
//  BaseDataObject.h
//  DropDownList
//
//  Created by Nick Marchenko on 22.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseDataObject : NSObject 

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) UIImage *image;

-(id)initWithName:(NSString*) name WithDescription:(NSString*) description WithImage:(UIImage*) image;

@end
