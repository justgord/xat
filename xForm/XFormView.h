//
//  XFormView.h
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import <UIKit/UIKit.h>
#import "XUtil.h"
#import "XNotify.h"


@interface XFormView : UITableViewController  <UITextFieldDelegate, NotifyValueChange>
{
	id			_metadata;
	id			_data;
	id			_type;	
	
	id*			_item_cells;
	int			_ncurrent_cell;	
	
	id			_textfield_attrs;
	
	UIColor*	_bg_color;
	UIColor*	_sep_color;
}

-(id)initWithData:(id)data Type:(NSString*)stype Metadata:(id)md Name:(NSString*)sname;

-(void)changeAtt:(NSString*)satt ToValue:(id)value;

@end
