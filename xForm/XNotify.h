//
//  XNotify.h
//  xForm
//
//  Created by gordon on 2010/09/17.
//  Copyright 2010 anderson web systems. All rights reserved.
//  released under BSD open source licence

#import <Foundation/Foundation.h>


@protocol NotifyValueChange<NSObject>
@optional

-(void)changeAtt:(NSString*)satt ToValue:(id)value;

@end


@interface XNotify : NSObject <NotifyValueChange> {
	
	id _handlers;

}

-(void)changeAtt:(NSString*)satt ToValue:(id)value;

-(void)addHandler:(id<NotifyValueChange>)notify_sink forScope:(NSString*)scope;

+(XNotify*)globalNotify;

@end
