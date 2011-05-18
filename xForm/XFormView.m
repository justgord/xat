//
//  XFormView.m
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import "XFormView.h"
#import "xat.h"
#import "XFormSelect.h"


@implementation XFormView


#pragma mark Initialization


-(id)initWithData:(id)data Type:(NSString*)stype Metadata:(id)md Name:(NSString*)sname
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) 
	{
		_metadata = md;
		_data = data;
		
		[_metadata retain];
		
		_type = at(at(_metadata, @"types"), stype);
		
		int N = atcnt(_type);
		_item_cells		= calloc(sizeof(id), N);
		for (int i=0;i<N;i++)
		{
			_item_cells[i] = nil;
		}
		_ncurrent_cell=0;
		
		_textfield_attrs = atmap();
		
		_bg_color = [[UIColor colorWithRed:211.0/256 green:227.0/256 blue:227.0/256 alpha:1.0] retain];
		_sep_color = [[UIColor colorWithRed:211.0/300 green:227.0/300 blue:227.0/300 alpha:1.0] retain];
		
		if (!_type)
			NSLog(@"ERROR : XFormView::initWithData : Unknown type [%@]", stype);
		
		[self setTitle:sname];
    }
    return self;
}

#pragma mark set data

-(void)setAttr:(NSString*)sattr Val:(NSString*)sval
{
	//NSLog(@"EditText : %@ = %@",  sattr, sval);
	
	atset(_data, sattr, sval); 
}


#pragma mark NotifyValueChange

-(void)changeAtt:(NSString*)satt ToValue:(id)val
{
	// update the current cells edit box with contents of multi select
	
	id cell = _item_cells[_ncurrent_cell];
	id vw = [cell viewWithTag:201];
	if (vw)
	{
		[vw setText:val];
		
		id attrdef = atn(_type, _ncurrent_cell);
		NSString* sattr_id = at(attrdef, @"id");
		[self setAttr:sattr_id Val:val];
	}
}


#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:_bg_color];
	[self.tableView setSeparatorColor:_sep_color];
}


#pragma mark UITextFieldxxx

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
	[tf resignFirstResponder];
	return YES;
}


-(void)textFieldDidChange:(id)sender
{	
	NSString* sob = [[NSNumber numberWithUnsignedInt:[sender hash]] stringValue];
	NSString* sattr = at(_textfield_attrs, sob);
	NSString* stext = [sender text];
	
	[self setAttr:sattr Val:stext];
}


-(id)makeTextFieldFor:(NSString*)sattrid
{
	UITextField* tf	= [[UITextField alloc] initWithFrame:CGRectMake(10, 36, 300, 24)];
	
	tf.borderStyle			= UITextBorderStyleRoundedRect;
	tf.textColor			= [UIColor blackColor];
	tf.font					= [UIFont systemFontOfSize:16.0];
	tf.text					= at(_data, sattrid);
	tf.backgroundColor		= _bg_color;
	tf.autocorrectionType	= UITextAutocorrectionTypeNo;
	tf.keyboardType			= UIKeyboardTypeDefault;
	tf.returnKeyType		= UIReturnKeyDone;
	tf.clearButtonMode		= UITextFieldViewModeWhileEditing;
	tf.tag					= 201;
	tf.delegate				= self;	
	
	NSString* sob = [[NSNumber numberWithUnsignedInt:[tf hash]] stringValue];
	atset(_textfield_attrs, sob, sattrid);
	
	[tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	return tf;
}


-(BOOL)isEditType:(NSString*)stype
{
	return ([stype isEqual:@"enum"] || 
			[stype isEqual:@"multi"] ||
			[stype isEqual:@"phone"] ||
			[stype isEqual:@"email"] ||
			[stype isEqual:@"string"] );
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{    
	return atcnt(_type);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int n = [indexPath indexAtPosition:1];
	id attrdef = atn(_type, n);
	NSString* satt_type = at(attrdef, @"type");	
	if ([self isEditType:satt_type])
		return 66;
	return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];
	
	id attrdef = atn(_type, n);
	
    UITableViewCell* cell = _item_cells[n];
	if (!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] retain];
		_item_cells[n]=cell;
		
		NSString* satt_type = at(attrdef, @"type");	
		if ([self isEditType:satt_type])
		{
			id tf = [self makeTextFieldFor:at(attrdef, @"id")];
			[cell.contentView addSubview:tf];
		}
		
		UIImage *hint=nil;
		if ([satt_type isEqual:@"enum"] || [satt_type isEqual:@"multi"])
		{
			hint = [UIImage imageNamed:@"sub_multi.png"];
		}
		if ([satt_type isEqual:@"ref"])
		{
			hint = [UIImage imageNamed:@"sub_ref.png"];
		}
		if (hint)
		{
			NSLog(@"HAVE HINT IMAGE!!");
			UIImageView* vwhint  = [[UIImageView alloc] initWithImage:hint]; 
			[vwhint setFrame:CGRectMake(264, 8, 48, 24)];
			[cell.contentView addSubview:vwhint];
	    }
	}
	
	NSString* s = [NSString stringWithFormat:@"%@", at(attrdef, @"id")];

	UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 264, 24)];
	[name setText:s];
	[name setFont:[UIFont systemFontOfSize:18.0]];
	[name setBackgroundColor:_bg_color];
	[cell.contentView addSubview:name];
    
    return cell;
}

#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int n = [indexPath indexAtPosition:1];	
	_ncurrent_cell = n;
	
	id attrdef = atn(_type, n);	
	NSString* satt_id = at(attrdef, @"id");	
	
	NSString* satt_type = at(attrdef, @"type");	
	if ([satt_type isEqual:@"enum"] || [satt_type isEqual:@"multi"])
	{
		// enum multichoice 
		
		NSString* senum = at(attrdef, @"enum");
		id enums = at(_metadata, @"enums");
		id options = at(enums, senum);
		
		id dvc = [[XFormSelect alloc] initWithItems:options Sink:self OptionString:at(_data, satt_id) Name:satt_id];
		[self.navigationController pushViewController:dvc animated:YES];
		[dvc release];		
	}
	else if([satt_type isEqual:@"ref"])
	{				
		id data = at(_data, satt_id);
		if (!data)
		{
			NSLog(@"No data for %@ : making empty one", satt_id);
			data = atmap();
			atset(_data, satt_id, data);
		}
		id dvc = [[XFormView alloc] initWithData:data Type:at(attrdef, @"target") Metadata:_metadata Name:satt_id];
		[self.navigationController pushViewController:dvc animated:YES];
		[dvc release];	
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
	for(int i=0;i<atcnt(_type);i++)
	{
		[_item_cells[i] release];
	}	
	free(_item_cells);
	
	[_bg_color release];
	[_sep_color release];
    [super dealloc];
}


@end

