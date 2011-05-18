//
//  XNotify.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XNotify.h"
#include "xat.h"

static XNotify* _global_notify=NULL;


@implementation XNotify

-(id)init
{
	_handlers = atmap();
	return self;
}

+(XNotify*)globalNotify
{
	if (_global_notify)
		return _global_notify;
	
	return _global_notify = [[XNotify alloc] init];
}

-(void)changeAtt:(NSString*)satt ToValue:(id)value
{
	//notify any handlers registered with matching scope 
	
	for (NSString* scope in _handlers)
	{
		if ([satt hasPrefix:scope])
		{
			id handler = at(_handlers, scope);
			[handler changeAtt:satt ToValue:value];
		}
	}
}

-(void)addHandler:(id<NotifyValueChange>)notify_sink forScope:(NSString*)scope
{
	//TODO //dont overwrite!!
	atset(_handlers, scope, notify_sink);
}



@end
