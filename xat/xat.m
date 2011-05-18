//
// xat.h
//
//      xilla atxxx function library : 
//
//          terse syntax for Cocoa JSON/arrays/maps
//
// copyright (c) gordon anderson 2009
// released under BSD open source licence


#import "xat.h"

id atlst()
{
	return [[NSMutableArray alloc] init];
}

id atmap()
{
	return [[NSMutableDictionary alloc] init];	
}

id atpush(id ob, id elt)
{
	if (!ob || !elt)
		return NULL;	
		
	if (![ob isKindOfClass:[NSMutableArray class]])
	{
		NSLog(@"ERROR : atpush : push target not a mutable array.");
		return NULL;		
	}
	
	[(NSMutableArray*)ob addObject:elt];		// append
	return ob;
}

id atpop(id ob)
{
	if (!ob)
		return NULL;	
	
	if (![ob isKindOfClass:[NSMutableArray class]])
	{
		NSLog(@"ERROR : atpush : push target not a mutable array.");
		return NULL;		
	}
	if(atcnt(ob)<1)
		return NULL;
	
	id elt = [ob lastObject];
	[ob removeLastObject];
	return elt;
}

id	atpushfront(id ob, id elt)
{
	if (!ob || !elt)
		return NULL;	
	
	if (![ob isKindOfClass:[NSMutableArray class]])
	{
		NSLog(@"ERROR : atpush : push target not a mutable array.");
		return NULL;		
	}
	
	[ob insertObject:elt atIndex:0];		// insert at front
	return ob;
}


int	atcnt(id ob)
{
	if (!ob)
		return 0;	
	
	if ([ob isKindOfClass:[NSArray class]])
	{
		return [ob count];
	}
	
	if ([ob isKindOfClass:[NSDictionary class]])
	{
		return [ob count];
	}	
	
	return 0;
}


void atlogm(id ob, NSString* msg)
{
	//NSLog(@"%@", ob);
	
	//NSLog(@"%@:\n%@", msg, [[CJSONSerializer serializer] serializeObject:ob]);			//need pretty printing
	
	//NSLog(@"%@:\n%@", msg, [ob JSONRepresentation]);
	NSLog(@"%@ : %@", msg, ob);
}

void atlog(id ob)
{
	atlogm(ob, @"");
}




id at(id ob, NSString* k)
{
	if (ob && [ob isKindOfClass:[NSDictionary class]])
	{
		return [ob objectForKey:k];
	}
	
	return NULL;	
}

id atn(id ob, int k)
{
	if (ob && [ob isKindOfClass:[NSArray class]])
	{
		if (k < [ob count])
			return [ob objectAtIndex:k];
	}
	
	return NULL;	
}

NSArray* atkeys(id ob)
{
	if (ob && [ob isKindOfClass:[NSDictionary class]])
	{
		NSDictionary* map = (NSDictionary*)ob;
		
		NSMutableArray* keys = [[NSMutableArray alloc] init];
		
		for(id key in map)
		{
			[keys addObject:key];
		}
		
		// sort alphabetical by default
		
		return [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	}
	
	return NULL;
}


id atset(id ob, NSString* att, id val)
{
	if (ob && val && [ob isKindOfClass:[NSMutableDictionary class]])
	{
		NSMutableDictionary* map = (NSMutableDictionary*)ob;
		
		[map setValue:val forKey:att];
		
		return ob;		
	}
	
	return NULL;
}

id atsetn(id ob, int i, id val)
{
	if (ob && [ob isKindOfClass:[NSMutableArray class]])
	{
		NSMutableArray* arr = (NSMutableArray*)ob;

		if (i < [arr count])
			[arr replaceObjectAtIndex:i withObject:val];
		else 
			return NULL;									// for now disallow auto-extend to avoid unfilled elements
	}
	return NULL;
}

id atpath(id ob, NSString* sPath)
{
	// walk down path, return val if found, or NULL
	
	if (!sPath || !ob)
		return NULL;
	
	NSArray* stack = [sPath componentsSeparatedByString:@"/"];
	
	id o=ob;
	for(id s in stack)
	{		
		if ([s length]>0)
		{
			id n = at(o, s);
			if (!n)
				return NULL;				// path component not there
			o=n;
		}
	}
	return o;	
}


id atsetpath(id ob, NSString* sPath, id val)
{
	if (!sPath || !ob)
		return NULL;

	// walk down tree path, or create it
	// set end item to val
	// val can be NULL, in which case we just create the path
	
	NSArray* stack = [sPath componentsSeparatedByString:@"/"];
	
	id o=ob;
	for(id s in stack)
	{		
		if (s==[stack lastObject])
		{
			if (val)
				atset(o, s, val);			// set the value
		}
		else if ([s length]>0)
		{
			id n = at(o, s);
			if (!n)
			{
				n = atmap();
				atset(o, s, n);				// construct the path thats not there
			}
			o=n;
		}
	}
	return ob;
}

bool ateq(id ob, NSString* att, id val)
{
	if (!val)
		return false;
	
	id test = at(ob, att);
	if (!test)
		return false;
	
	if ([val class]!=[test class])
		return false;
	
	//NSLog(@"ateq : at([%@] [%@]) ==? [%@]\n", ob, att, val);
	
	return 0==[test compare:val];
}

NSString* atuuid()
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}

id atcopydeep(id src)
{
	if ([src isKindOfClass:[NSDictionary class]])
	{
		id dst = atmap();
		for (id key in src)
		{
			id item = atcopydeep(at(src, key));
			atset(dst, key, item); 
		}
		return dst;
	}
	
	if ([src isKindOfClass:[NSArray class]])
	{
		id dst = atlst();
		for (int i=0;i<atcnt(dst);i++)
		{
			id item = atcopydeep(atn(src, i));
			atpush(dst, item); 
		}
		return dst;
	}
	
	if ([src isKindOfClass:[NSNumber class]])
		return [src copy];
	
	return [src mutableCopy];
}

