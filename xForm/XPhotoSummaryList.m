//
//  XPhotoSummaryList.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XPhotoSummaryList.h"
#import "xat.h"
#import "XUtil.h"
#import "XDetailList.h"
#import "XCellMaker.h"



@implementation XPhotoSummaryList

#pragma mark Initialization


-(id)initWithConfig:(id)config jsonTree:(id)tree
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) 
	{
		_config = config;
		_tree = tree;
		NSString* sdatasource = atpath(config, @"view_config/data_source");
		_data = atpath(tree, sdatasource);
		
		_photo_attr = atpath(_config, @"view_config/photo_attr");
		_line1_attr = atpath(_config, @"view_config/line1_attr");
		_line2_attr = atpath(_config, @"view_config/line2_attr");
		_line3_attr = atpath(_config, @"view_config/line3_attr");
		_line4_attr = atpath(_config, @"view_config/line4_attr");
		
		_bg_color		= [UIColor whiteColor];
		_sep_color		= rgbcnf(tree, @"sec_5");
		_line1_color	= rgbcnf(tree, @"pri_3");
		_line2_color	= rgbcnf(tree, @"pri_2");
		_line3_color	= rgbcnf(tree, @"pri_3");
		
		_imgblank = [UIImage imageNamed:@"blank_profile.th.jpg"];
		
		_img_fav_off = [UIImage imageNamed:@"fav_off.png"];
		_img_fav_on  = [UIImage imageNamed:@"fav_on.png"];	
		
		_img_chkin_off = [UIImage imageNamed:@"chkin_off.png"];
		_img_chkin_on  = [UIImage imageNamed:@"chkin_on.png"];	
		
		[self setTitle:at(config, @"name")];
    }
    return self;
}


#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:_bg_color];
	[self.tableView setSeparatorColor:_sep_color];
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{    
	return atcnt(_data);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}




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
	
	[XCellMaker setCellIcons:cell forItem:item];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];
	
	id item = atn(_data, n);

    UITableViewCell* cell = [XCellMaker makeCell:@"Cell_XPhotoSummaryList"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[self setCell:cell Item:item];
    
    return cell;

}

#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];
	
	UIViewController *dvc = [[XDetailList alloc] initWithConfig:_config jsonTree:_tree nthItem:n];
	[self.navigationController pushViewController:dvc animated:YES];
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

