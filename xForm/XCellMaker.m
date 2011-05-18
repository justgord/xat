//
//  XCellMaker.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XCellMaker.h"
#import "XUtil.h"
#import "xat.h"

static XCellMaker* _gcellmaker = NULL;


@implementation XCellMaker

-(id)init
{
	self = [super init];
    if (self) 
	{
		_bg_color		= [UIColor whiteColor];
		_sep_color		= rgbcol(255,191,115);
		_line1_color	= rgbcol(3,69,105);
		_line2_color	= rgbcol(35,91,121);
		_line3_color	= _line1_color;
		
		_imgblank = [UIImage imageNamed:@"blank_profile.th.jpg"];
		
		_img_fav_off = [UIImage imageNamed:@"fav_off.png"];
		_img_fav_on  = [UIImage imageNamed:@"fav_on.png"];	
		
		_img_chkin_off = [UIImage imageNamed:@"chkin_off.png"];
		_img_chkin_on  = [UIImage imageNamed:@"chkin_on.png"];
		
		_gcellmaker = self;
	}
	return self;
}

-(id)make_XPhotoSummaryList
{
	static NSString *cell_id = @"Cell_XPhotoSummaryList";
	UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_id] autorelease];
	
	// photo, label, label, label
	
	UIImageView* vwimg = [[UIImageView alloc] initWithImage:_imgblank];
	[vwimg setTag:1];
	[vwimg setFrame:CGRectMake(10, 3, 72, 72)];
	[cell.contentView addSubview:vwimg];
	
	float y=2.0;	
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, y, 200, 20)];
		[lbl setFont:[UIFont systemFontOfSize:16.0]];
		[lbl setTag:2];
		[lbl setBackgroundColor:_bg_color];
		[lbl setTextColor:_line1_color];
		[cell.contentView addSubview:lbl];
	}
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, y+=20, 200, 20)];
		[lbl setFont:[UIFont systemFontOfSize:14.0]];
		[lbl setTag:3];
		[lbl setBackgroundColor:_bg_color];
		[lbl setTextColor:_line2_color];	
		[cell.contentView addSubview:lbl];
	}
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(100,  y+=18, 200, 20)];
		[lbl setFont:[UIFont systemFontOfSize:14.0]];
		[lbl setTag:4];
		[lbl setBackgroundColor:_bg_color];
		[lbl setTextColor:_line3_color];	
		[cell.contentView addSubview:lbl];
	}
	{	
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(100,  y+=18, 200, 16)];
		[lbl setFont:[UIFont systemFontOfSize:13.0]];
		[lbl setTag:5];
		[lbl setBackgroundColor:_bg_color];
		[lbl setTextColor:_line2_color];	
		[cell.contentView addSubview:lbl];
	}
	
	// favourite + checked-in
	
	{
		UIImageView* vwimg = [[UIImageView alloc] initWithImage:_img_fav_off];
		[vwimg setTag:700];
		[vwimg setFrame:CGRectMake(278, 3, 19, 19)];
		[cell.contentView addSubview:vwimg];
	}
	{
		UIImageView* vwimg = [[UIImageView alloc] initWithImage:_img_fav_on];
		[vwimg setTag:701];
		[vwimg setFrame:CGRectMake(278, 3, 19, 19)];
		[cell.contentView addSubview:vwimg];
	}
	{		
		UIImageView* vwimg = [[UIImageView alloc] initWithImage:_img_chkin_off];
		[vwimg setTag:710];
		[vwimg setFrame:CGRectMake(295, 5, 16, 16)];
		[cell.contentView addSubview:vwimg];
	}
	{
		UIImageView* vwimg = [[UIImageView alloc] initWithImage:_img_chkin_on];
		[vwimg setTag:711];
		[vwimg setFrame:CGRectMake(295, 5, 16, 16)];
		[cell.contentView addSubview:vwimg];		
	}	
	
	return cell;
}


-(UITableViewCell*) make_XDetailListLine
{
	static NSString *cell_id = @"Cell_XDetailListLine";
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_id] autorelease];
	
	// label : value
	
	float y=4.0;
	float x0=10.0;
	float x1=100.0; 
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(x0, y, 90, 20)];
		[lbl setFont:[UIFont systemFontOfSize:13.0]];
		[lbl setTag:101];
		[lbl setBackgroundColor:_bg_color];
		[lbl setTextColor:_line2_color];
		[cell.contentView addSubview:lbl];
	}
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(x1, y, 220, 20)];
		[lbl setFont:[UIFont systemFontOfSize:14.0]];
		[lbl setTag:102];
		[lbl setBackgroundColor:_bg_color];
		[lbl setTextColor:_line1_color];
		[cell.contentView addSubview:lbl];
	}	
	
	return cell;
}

-(UITableViewCell*) make_XDetailListTextLine
{
	static NSString *cell_id = @"Cell_XDetailListTextLine";
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_id] autorelease];
	
	// label : value
	
	float y=4.0;
	float x0=10.0;
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(x0, y, 90, 20)];
		[lbl setFont:[UIFont systemFontOfSize:13.0]];
		[lbl setTag:101];
		[lbl setBackgroundColor:_bg_color];
		[lbl setTextColor:_line2_color];
		[cell.contentView addSubview:lbl];
	}
	{
		UITextView* vw = [[UITextView alloc] initWithFrame:CGRectMake(2, y+24, 260, 120)];
		[vw setFont:[UIFont systemFontOfSize:13.0]];
		[vw setTag:102];
		[vw setBackgroundColor:_bg_color];
		[vw setTextColor:_line1_color];
		[vw setEditable:NO];
		[cell.contentView addSubview:vw];
	}	
	
	return cell;
}


-(UITableViewCell*) make_XDetailActionLine
{
	static NSString *cell_id = @"Cell_XDetailActionLine";
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_id] autorelease];
	
	id bgcol = rgbcol(226,242,255);
	cell.contentView.backgroundColor = bgcol;
	//  [ Action ] * button
	
	float y=4.0;
	float x0=80.0;
	float x1=100.0; 
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(x0, y, 90, 20)];
		[lbl setFont:[UIFont systemFontOfSize:14.0]];
		[lbl setTag:101];
		[lbl setBackgroundColor:bgcol];
		[lbl setTextColor:_line2_color];
		[lbl setText:@">"];
		[cell.contentView addSubview:lbl];
	}
	{
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(x1, y, 220, 20)];
		[lbl setFont:[UIFont systemFontOfSize:16.0]];
		[lbl setTag:102];
		[lbl setBackgroundColor:bgcol];
		[lbl setTextColor:_line1_color];
		[cell.contentView addSubview:lbl];
	}	
	
	return cell;
}


-(id)new_cell:(NSString*)scell_type
{
	if ([scell_type isEqualToString:@"Cell_XPhotoSummaryList"])
		return [self make_XPhotoSummaryList];
	
	if ([scell_type isEqualToString:@"Cell_XDetailListLine"])
		return [self make_XDetailListLine];		
	
	if ([scell_type isEqualToString:@"Cell_XDetailListTextLine"])
		return [self make_XDetailListTextLine];	
	
	if ([scell_type isEqualToString:@"Cell_XDetailActionLine"])
		return [self make_XDetailActionLine];		
	

	NSLog(@"ERROR: unknown cell type : %@", scell_type);
	return NULL;
}




#pragma mark globals

+(id)makeCell:(NSString*)scell_type
{
	if (!_gcellmaker)
		_gcellmaker = [[XCellMaker alloc] init];
	
	return [_gcellmaker new_cell:scell_type];
}

+(void)setLineCell:(UITableViewCell*)cell Label:(NSString*)slabel Text:(NSString*)stext
{	
	{
		UILabel* lbl = (UILabel*)[cell viewWithTag:101];
		[lbl setText:slabel];
	}
	{
		UILabel* lbl = (UILabel*)[cell viewWithTag:102];
		[lbl setText:stext];
	}		
}


+(void)setCellIcons:(UITableViewCell*)cell forItem:(id)item
{
	
	// show/hide checkin and favourite statuses
	
	NSString* sfav = at(item, @"_favourite");
	if (sfav)
	{
		BOOL bfav = (sfav && [sfav isEqualToString:@"yes"]);
		{
			UIView* vw = [cell viewWithTag:700];
			if (vw)
				[vw setAlpha:bfav ? 0.0 : 1.0];
		}
		{
			UIView* vw = [cell viewWithTag:701];
			if (vw)
				[vw setAlpha:bfav ? 1.0 : 0.0];
		}
	}
	
	NSString* schkin = at(item, @"_checked_in");
	if (schkin)
	{
		BOOL bin = (schkin && [schkin isEqualToString:@"yes"]);
		{
			UIView* vw = [cell viewWithTag:710];
			if (vw)
				[vw setAlpha:bin ? 0.0 : 1.0];
		}
		{
			UIView* vw = [cell viewWithTag:711];
			if (vw)
				[vw setAlpha:bin ? 1.0 : 0.0];
		}	
	}
	
}
	


@end
