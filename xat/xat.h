//
// xat.h
//
//      xilla atx function library : 
//          terse Cocoa syntax for JSON/arrays/maps
//
//          usage : 
//				id x = at(at(at(json, @"country"), @"state"), @"city");		// chainable access or
//              id x = atpath(@"country/state/city");						// drillable access
//
//
// copyright (c) gordon anderson 2009
// released under BSD open source licence

id          atlst();                                // create new list : a NSMutableArray
id          atmap();                                // create new map : a NSMutableDictionary

id          at(id ob, NSString* k);                 // lookup item in map using key k
id          atn(id ob, int k);                      // get item at position k in list
int         atcnt(id ob);                           // count of map or list
NSArray*    atkeys(id ob);                          // return list with all keys from map              

id          atset(id ob, NSString* att, id val);			// set ob[att] = val
id          atsetn(id ob, int i, id val);					// set ob[i] = val

id			atpath(id ob, NSString* path);					// walk down path, return val if found, or NULL
id			atsetpath(id ob, NSString* sPath, id val);		// walk down path, or create it, set val there

id          atpush(id ob, id elt);                  // append to end of list
id			atpop(id ob);							// pop off last elt 
id			atpushfront(id ob, id elt);				// push onto front

bool        ateq(id ob, NSString* att, id val);     // check equality : ob[att] == val ?

void        atlog(id ob);                           // log output
void        atlogm(id ob, NSString* msg);           // log with message text

id			atcopydeep(id src);						// returns mutable deep copy of list, map and item tree

NSString*   atuuid();                               // create a statistically uniq id

