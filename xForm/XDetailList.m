//
//  XDetailList.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XDetailList.h"
#import "XCellMaker.h"
#import "xat.h"
#import "XUtil.h"


int skipcol(id type)
{
	id sid = at(type, @"id");
	id stype = at(type, @"type");
	
	if ([sid hasPrefix:@"_"])
		return true;
		
	if(at(type, @"hide"))
		return true;
	
	if ([stype isEqualToString:@"image"])
		return true;
	
	
	
	if ([sid isEqualToString:@"position"])
		return true;
	if ([sid isEqualToString:@"name"])
		return true;
	if ([sid isEqualToString:@"surname"])
		return true;
	if ([sid isEqualToString:@"company"])
		return true;
	if ([sid isEqualToString:@"website"])
		return true;	
	
	return false;
}


@implementation XDetailList

#pragma mark Initialization




-(id)initWithConfig:(id)config jsonTree:(id)tree nthItem:(int)nItem
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) 
	{
		_config = config;
		NSString* sdatasource = atpath(config, @"view_config/data_source");
		_data = atpath(tree, sdatasource);
		_item = atn(_data, nItem);
		
		id _type_name = at(_item, @"_type");
		_type_info = at(atpath(tree, @"metadata/types"), _type_name);
		
		_cells = atlst();
		
		_photo_attr = atpath(_config, @"view_config/photo_attr");
		_line1_attr = atpath(_config, @"view_config/line1_attr");
		_line2_attr = atpath(_config, @"view_config/line2_attr");
		_line3_attr = atpath(_config, @"view_config/line3_attr");
		_line4_attr = atpath(_config, @"view_config/line4_attr");
		
		_bg_color		= rgbcol(255, 255, 255);
		_sep_color		= rgbcol(220, 220, 220); //rgbcnf(tree, @"sec_5");
		_line1_color	= rgbcnf(tree, @"pri_3");
		_line2_color	= rgbcnf(tree, @"pri_2");
		_line3_color	= rgbcnf(tree, @"pri_3");
		
		_imgblank = [UIImage imageNamed:@"blank_profile.th.jpg"];
		
		_img_fav_off = [UIImage imageNamed:@"fav_off.png"];
		_img_fav_on  = [UIImage imageNamed:@"fav_on.png"];	
		
		_img_chkin_off = [UIImage imageNamed:@"chkin_off.png"];
		_img_chkin_on  = [UIImage imageNamed:@"chkin_on.png"];	
		
		[self setTitle:at(config, @"detail_name")];
    }
    return self;
}


#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:_bg_color];
	[self.tableView setSeparatorColor:_sep_color];
	
	[self makeAllCells];
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{    
	if (section==0)
		return atcnt(_cells);
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int n = [indexPath indexAtPosition:1];
	NSString* sh = at(atn(_cells, n), @"height");
	return [sh floatValue];
}


#pragma mark make top cell



-(void)setCell:(UITableViewCell*)cell Item:(id)item
{	
	UIImageView* vwimg = (UIImageView*)[cell viewWithTag:1];
	UIImage* img = [UIImage imageNamed:at(item, _photo_attr)];	//TODO //cache
	if (!img)
		img = _imgblank;
	[vwimg setImage:img];
	
	{
		UILabel* lbl = (UILabel*)[cell viewWithTag:2];
		[lbl setText:at(item, _line1_attr)];
	}
	{
		UILabel* lbl = (UILabel*)[cell viewWithTag:3];
		[lbl setText:at(item, _line2_attr)];
	}
	{
		UILabel* lbl = (UILabel*)[cell viewWithTag:4];
		[lbl setText:at(item, _line3_attr)];	 
	}
	{
		UILabel* lbl = (UILabel*)[cell viewWithTag:5];
		[lbl setText:at(item, _line4_attr)];	 
	}		
}

#pragma mark make line cell

-(void)addAction:(NSString*)name scope:(NSString*)scope
{
	id cell = [XCellMaker makeCell:@"Cell_XDetailActionLine"];
	[XCellMaker setLineCell:cell Label:@">" Text:name];
	
	id entry = atmap();
	atset(entry, @"cell", cell);
	atset(entry, @"height", @"30");
	atset(entry, @"action", scope);
	atpush(_cells, entry);			
}


-(void)makeAllCells
{
	if (atcnt(_cells)>0)
		return;
	
	_line_ids = atlst();
	_line_labels = atlst();
	_attr_map = atmap();
	int nlines=0;
	for(int i=0;i<atcnt(_type_info);i++)
	{
		id attr = atn(_type_info,i);
		NSString* sid		= at(attr, @"id");  
		//NSString* stype		= at(attr, @"type");  
		NSString* slabel	= at(attr, @"label");
		NSString* sval		= at(_item, sid);
		
		// if its viewable, add a cell for it
		
		if (!skipcol(attr) && slabel && sval)
		{
			atpush(_line_ids, sid);
			atpush(_line_labels, slabel);
			
			atset(_attr_map, sid, attr);
			nlines++;
		}
	}
	
	// top cell
	
	id cell = [XCellMaker makeCell:@"Cell_XPhotoSummaryList"];
	[self setCell:cell Item:_item];
	[XCellMaker setCellIcons:cell forItem:_item];
	
	id entry = atmap();
	atset(entry, @"cell", cell);
	atset(entry, @"height", @"80");
	atpush(_cells, entry);
	
	// each line cell [ special case for text cells ]
	
	for (int n=0;n<nlines;n++)
	{
		NSString* sid		= atn(_line_ids, n);
		id attr				= at(_attr_map, sid);
		NSString* stype		= at(attr, @"type");
		
		NSString* slabel	= atn(_line_labels, n);
		NSString* sval		= at(_item, sid);
		if (!sval)
			sval = @"";
		
		if ([stype isEqualToString:@"text"])
		{
			id cell = [XCellMaker makeCell:@"Cell_XDetailListTextLine"];
			[XCellMaker setLineCell:cell Label:slabel Text:sval];
			
			id entry = atmap();
			atset(entry, @"cell", cell);
			atset(entry, @"height", @"160");
			atpush(_cells, entry);			
		}
		else
		{
			id cell = [XCellMaker makeCell:@"Cell_XDetailListLine"];
			[XCellMaker setLineCell:cell Label:slabel Text:sval];
			
			id entry = atmap();
			atset(entry, @"cell", cell);
			atset(entry, @"height", @"30");
			atpush(_cells, entry);			
		}
	}
	
	// action buttons - if any for this type
	
	NSString* stype = at(_item, @"_type");
	if ([stype isEqualToString:@"attendee"])
	{		
		BOOL bConnected = [@"yes" isEqualToString:at(_item, @"_connected")];
		
		if (!bConnected)
			[self addAction:@"Connect" scope:@"ui/attendee/connect"];
			
		if(bConnected)
		{
			[self addAction:@"Message" scope:@"ui/attendee/message"];
			[self addAction:@"Disconnect" scope:@"ui/attendee/disconnect"];
		}
		
		[self addAction:@"Report" scope:@"ui/attendee/report"];
	}
	if ([stype isEqualToString:@"speaker"])
	{		
		BOOL bConnected = [@"yes" isEqualToString:at(_item, @"_connected")];
		
		if (!bConnected)
			[self addAction:@"Connect" scope:@"ui/attendee/connect"];
	}
}


#pragma mark Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];

	UITableViewCell* cell=at(atn(_cells, n), @"cell");

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];
	
	id entry = atn(_cells, n);
	NSString* saction = at(entry, @"action");
	if (saction)
	{
		NSLog(@"action : %@ for item %@", saction, at(_item, @"id"));
	}
}


#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
}


- (void)dealloc 
{
	[_bg_color release];
	[_sep_color release];
    [super dealloc];
}


@end

