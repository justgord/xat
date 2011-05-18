//
//  XMenuList.h
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import <UIKit/UIKit.h>
#import "XUtil.h"
#import "XNotify.h"


@interface XMenuList : UITableViewController 
{
	id			_config;
	id			_data;
	
	UIImage*	_imgblank;
	
	UIColor*	_bg_color;
	UIColor*	_sep_color;
	
	id<NotifyValueChange>	_changeNotify;
}

-(id)initWithConfig:(id)config jsonTree:(id)tree;

-(void)setNotifyHandler:(id<NotifyValueChange>)handler;

@end
