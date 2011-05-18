//
//  XCellMaker.h
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import <Foundation/Foundation.h>


@interface XCellMaker : NSObject {
	
	UIColor*	_bg_color;	
	UIColor*	_sep_color;
	UIImage*	_imgblank;

	UIColor*	_line1_color;
	UIColor*	_line2_color;
	UIColor*	_line3_color;
	
	UIImage*	_img_fav_off;
	UIImage*	_img_fav_on;
	
	UIImage*	_img_chkin_off;
	UIImage*	_img_chkin_on;	
	
}

-(id)new_cell:(NSString*)scell_type;


+(id)makeCell:(NSString*)scell_type;

+(void)setLineCell:(UITableViewCell*)cell Label:(NSString*)slabel Text:(NSString*)stext;
+(void)setCellIcons:(UITableViewCell*)cell forItem:(id)item;

@end
