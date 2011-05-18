//
//  XMenuList.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XMenuList.h"
#import "xat.h"



@implementation XMenuList


#pragma mark Initialization

-(id)initWithConfig:(id)config jsonTree:(id)tree
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) 
	{
		_config = tree;
		_data	= config;
		
		_bg_color		= rgbcnf(tree, @"white");	
		_sep_color		= rgbcnf(tree, @"lt_gray");
		
		_imgblank = [UIImage imageNamed:@"blank_profile.th.jpg"];
		
		[self setTitle:@"Menu"];
    }
    return self;
}

-(void)setNotifyHandler:(id<NotifyValueChange>)handler
{
	_changeNotify = handler;
}


#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:_bg_color];
	[self.tableView setSeparatorColor:_sep_color];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1+atcnt(_data);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int n = [indexPath indexAtPosition:1];
	if(n==0)
		return 81;
	return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];
	if(n==0)
	{
		static NSString *cell_id = @"CellBanner";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id] autorelease];	
		
		UIImage* imgb = [UIImage imageNamed:atpath(_config, @"app/menu_header")];
		UIImageView* vwb = [[UIImageView alloc] initWithImage:imgb];
		[vwb setFrame:CGRectMake(0, 0, 320, 80)];
		[cell addSubview:vwb];
		
		return cell;
	}
	
    static NSString *cell_id = @"CellXMenu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id] autorelease];

	id item = atn(_data, n-1);
    
    NSString* sname = at(item, @"name");
	NSString* sicon = at(item, @"icon");
	
	[cell.imageView setImage:[UIImage imageNamed:sicon]];
	[cell.textLabel setText:sname];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];
	if (_changeNotify)
		[_changeNotify changeAtt:@"ui/home_menu/selected" ToValue:[NSNumber numberWithInt:n-1]];
}


#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

