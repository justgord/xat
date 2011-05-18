//
//  XFormSelect.h
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import <UIKit/UIKit.h>
#import "XUtil.h"
#import "XNotify.h"



@interface XFormSelect : UITableViewController 
{
	id						_items;
	id<NotifyValueChange>	_sink;
	
	int*		_item_checks;
	id*			_item_cells;
	
	UIImage*	_img_bool_off;
	UIImage*	_img_bool_on;
	
	UIColor*	_bg_color;
	UIColor*	_sep_color;	
}

-(id)initWithItems:(id)items Sink:(id<NotifyValueChange>)sink OptionString:(NSString*)soptions Name:(NSString*)sname;

@end
