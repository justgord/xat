//
//  XFormSelect.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XFormSelect.h"
#import "xat.h"


@implementation XFormSelect

#pragma mark Initialization

BOOL scontains(NSString* s, NSString* sub)
{
	if ([s length]==0)
		return NO;
		
	NSRange textRange;
	textRange =[[s lowercaseString] rangeOfString:[sub lowercaseString]];

	return (textRange.location != NSNotFound);
}


-(id)initWithItems:(id)items Sink:(id<NotifyValueChange>)sink OptionString:(NSString*)soptions Name:(NSString*)sname;
{	
	self = [super initWithStyle:UITableViewStylePlain];
    if (self) 
	{
		_items = items;
		
		_sink = sink;
		
		int N = atcnt(_items);
		
		_item_checks	= calloc(sizeof(int), N);
		_item_cells		= calloc(sizeof(id), N);
		
		for (int i=0;i<N;i++)
		{
			_item_checks[i]=scontains(soptions, atn(_items, i)) ? 1 : 0;	
			_item_cells[i] = nil;
		}
		
		_img_bool_off	= [UIImage imageNamed:@"bool_off.png"];
		_img_bool_on	= [UIImage imageNamed:@"bool_on.png"];
		
		[self setTitle:sname];
		
		_bg_color = [[UIColor colorWithRed:211.0/256 green:227.0/256 blue:227.0/256 alpha:1.0] retain];
		_sep_color = [[UIColor colorWithRed:211.0/300 green:227.0/300 blue:227.0/300 alpha:1.0] retain];		
    }
    return self;
}


#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:_bg_color];
	[self.tableView setSeparatorColor:_sep_color];
	
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{	
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return atcnt(_items);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];	
	
	id item = atn(_items, n);
	
	UITableViewCell *cell = _item_cells[n];
	if (cell==nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NO"] retain];
		
		UIImageView* vw_off = [[UIImageView alloc] initWithImage:_img_bool_off]; 
		UIImageView* vw_on  = [[UIImageView alloc] initWithImage:_img_bool_on]; 
		
		[vw_off setFrame:CGRectMake(288, 8, 24, 24)];
		[vw_on  setFrame:CGRectMake(288, 8, 24, 24)];
		
		[vw_off setTag:100];
		[vw_on  setTag:101];
		
		BOOL set = (1==_item_checks[n]);
		
		[vw_off setHidden:set];
		[vw_on  setHidden:!set];
		
		[cell addSubview:vw_off];
		[cell addSubview:vw_on];
		
		_item_cells[n]=cell;
	}
	
	UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 264, 24)];
	[name setText:item];
	[name setFont:[UIFont systemFontOfSize:18.0]];
	[name setBackgroundColor:_bg_color];
	[cell.contentView addSubview:name];
    
    return cell;
}



#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];	
	
	//id item = atn(_items, n);
	int c = _item_checks[n];
	
	if (c)
	{
		_item_checks[n] = 0;
		//NSLog(@" %@ [%s]", item, "0");
	}
	else {
		_item_checks[n] = 1;
		//NSLog(@" %@ [%s]", item, "1");
	}
	
	UITableViewCell *cell = _item_cells[n];
	
	[[cell viewWithTag:100] setHidden:!c];
	[[cell viewWithTag:101] setHidden:c];	
	
	// send back string  "optionA, optionB, optionC"
	
	NSString* s = [NSString string];
	int opts=0;
	for(int i=0;i<atcnt(_items);i++)
	{
		if (_item_checks[i])
		{
			if (opts++)
				s = [s stringByAppendingString:@", "];
			s = [s stringByAppendingString:atn(_items, i)];
		}
	}
	[_sink changeAtt:@"options_string" ToValue:s];
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
    [super dealloc];
	
	for(int i=0;i<atcnt(_items);i++)
	{
		[_item_cells[i] release];
	}
	
	free(_item_checks);
	free(_item_cells);
}


@end

