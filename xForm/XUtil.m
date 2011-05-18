//
//  XUtil.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XUtil.h"
#import "xat.h"


UIColor* rgbcol(float r, float g, float b)
{
	static float S = 256.0;
	return [[UIColor colorWithRed:r/S green:g/S blue:b/S alpha:1.0] retain];
}

UIColor* rgbcnf(id tree, NSString* col_id)
{
	id color_scheme = atpath(tree, @"config/color_scheme");
	NSString* srgb = at(color_scheme, col_id);
	if (!srgb)
	{
		NSLog(@"No color with id %@", col_id);
		return [UIColor redColor];
	}
	
	//NSLog(@"parse color %@ [%@]", col_id, srgb);   //eg srgb = "23,34,245"
	
	NSArray* stack = [srgb componentsSeparatedByString:@","];
	
	NSString* sr = atn(stack, 0);
	NSString* sg = atn(stack, 1);
	NSString* sb = atn(stack, 2);
	
	float r=0,g=0,b=0;
	if (sr)	r=[sr floatValue];
	if (sg) g=[sg floatValue];
	if (sb) b=[sb floatValue];
	return rgbcol(r,g,b);
}

NSString* suniq()
{
	static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	
	int lelen = [letters length];
	int len = 8;
	
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
    for (int i=0; i<len; i++) 
	{
		[randomString appendFormat: @"%c", [letters characterAtIndex: random() % lelen]];
	}
	
	return randomString;
}

NSString* stimestamp()
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd.hhmmssSSS"];
	
	NSString *sts = [dateFormat stringFromDate:[NSDate date]];
	
	[dateFormat release];
	return sts;
}