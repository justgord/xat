//
//  XDetailList.h
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import <UIKit/UIKit.h>


@interface XDetailList : UITableViewController
{
	id			_config;
	id			_data;
	
	id			_type_info;
	id			_item;
	id			_attr_map;
	
	id			_line_ids;
	id			_line_labels;
	
	id			_cells;

	UIColor*	_bg_color;	
	UIColor*	_sep_color;
	UIImage*	_imgblank;
	
	UIColor*	_line1_color;
	UIColor*	_line2_color;
	UIColor*	_line3_color;	
	
	NSString*	_photo_attr;
	NSString*	_line1_attr;
	NSString*	_line2_attr;
	NSString*	_line3_attr;
	NSString*	_line4_attr;	
	
	UIImage*	_img_fav_off;
	UIImage*	_img_fav_on;
	
	UIImage*	_img_chkin_off;
	UIImage*	_img_chkin_on;	
}

-(id)initWithConfig:(id)config jsonTree:(id)tree nthItem:(int)nItem;
-(void)makeAllCells;

@end
