//
//  BaseDataObject.m
//  DropDownList
//
//  Created by Nick Marchenko on 22.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseDataObject.h"


@implementation BaseDataObject

-(id)initWithName:(NSString*) name WithDescription:(NSString*) description WithImage:(UIImage*) image
{
	if (self=[super init]) 
	{
        if (name) {
            _name = name;
            [name retain];
        }
        if (description) {
            _description = description;
            [description retain];
        }
        if (image) {
            _image=image;
            [image retain];
        }

	}
	return self;
}

-(void)setName:(NSString *)name
{
    if (name) {
        _name = name;
        [name retain];
    }
}
-(void)setDescription:(NSString *)description
{
    if (description) {
        _description = description;
        [description retain];
    }
}
-(void)setImage:(UIImage *)image
{
    if (image) {
        _image=image;
        [image retain];
    }
}
-(void)dealloc
{
	[_name release];
	[_description release];
	[_image release];
	[super dealloc];
}

@end
