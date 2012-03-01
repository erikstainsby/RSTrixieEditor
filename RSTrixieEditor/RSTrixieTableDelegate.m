//
//  RSTrixieTableDelegate.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-29.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <RSTrixiePlugin/RSTrixieRule.h>
#import "RSTrixieTableDelegate.h"

@implementation RSTrixieTableDelegate


- (id)	newContentObjectForTableController:(GCGenericTableController*) cllr {
		// a generic empty row with our object
	return [[RSTrixieRule alloc] init];
}


- (id) tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	
		//	NSLog(@"%s- [%04d] column %@, row %lu", __PRETTY_FUNCTION__, __LINE__, [tableColumn identifier], row);
	
	id value = nil;
	RSTrixieRule * rule = [mContent objectAtIndex:row];
	
		// rule.action.selector
	if( [[tableColumn identifier] isEqualToString:@"selector"]){
		RSActionRule * ar = [rule action];
		value =  ar.selector;
		ar = nil;
	}
		// rule.action.event
	else if([[tableColumn identifier] isEqualToString:@"event"]) {
		RSActionRule * ar = [rule action];
		value =  ar.event;
		ar = nil;
	}
		// rule.action.preventDefault
	else if([[tableColumn identifier] isEqualToString:@"preventDefault"]) {
		RSActionRule * ar = [rule action];
		value =  ([ar preventDefault]) ? @"preventDefault":@"";
		ar = nil;
	}
		// rule.action.stopBubbling
	else if([[tableColumn identifier] isEqualToString:@"stopBubbling"]) {
		RSActionRule * ar = [rule action];
		value = ([ar stopBubbling]) ? @"stopBubbling":@"";
		ar = nil;
	}
		// rule.reactions.target
	else if([[tableColumn identifier] isEqualToString:@"target"]) {
		if( [[rule reactions] count]>0 ) {
			RSReactionRule * rr = [[rule reactions] objectAtIndex:0];
			value = rr.target;
			rr = nil;
		}
	}
		// rule.reactions.callback
	else if([[tableColumn identifier] isEqualToString:@"callback"]) {
		if( [[rule reactions] count]>0 ) {
			RSReactionRule * rr = [[rule reactions] objectAtIndex:0];
			value = rr.callback;
			rr = nil;
		}
	}
		// rule.reactions.delta
	else if([[tableColumn identifier] isEqualToString:@"action"]) {
		if( [[rule reactions] count]>0 ) {
			RSReactionRule * rr = [[rule reactions] objectAtIndex:0];
			value = rr.action;
			rr = nil;
		}
	}
		// rule.reactions.delta
	else if([[tableColumn identifier] isEqualToString:@"delta"]) {
		if( [[rule reactions] count]>0 ) {
			RSReactionRule * rr = [[rule reactions] objectAtIndex:0];
			value = rr.delta;
			rr = nil;
		}
	}
		// rule.reactions.delay
	else if([[tableColumn identifier] isEqualToString:@"delay"]) {
		if( [[rule reactions] count]>0 ) {
			RSReactionRule * rr = [[rule reactions] objectAtIndex:0];
			value = [NSNumber numberWithInteger:rr.delay];
		}
	}
		// rule.reactions.period
	else if([[tableColumn identifier] isEqualToString:@"period"]) {
		if( [[rule reactions] count]>0 ) {
			RSReactionRule * rr = [[rule reactions] objectAtIndex:0];
			value = [NSNumber numberWithInteger:rr.period];
			rr = nil;
		}
	}
		// rule.conditions.selector
	else if([[tableColumn identifier] isEqualToString:@"condition"]) {
		if( [[rule conditions] count]>0 ) {
			RSConditionRule * cr = [[rule conditions] objectAtIndex:0];
			value = cr.selector;
			cr = nil;
		}
	}	
		// rule.conditions.predicate
	else if([[tableColumn identifier] isEqualToString:@"predicate"]) {
		if( [[rule conditions] count]>0 ) {
			RSConditionRule * cr = [[rule conditions] objectAtIndex:0];
			value = cr.predicate;
			cr = nil;
		}
	}
		// rule.conditions.valueOf
	else if([[tableColumn identifier] isEqualToString:@"valueOf"]) {
		if( [[rule conditions] count]>0 ) {
			RSConditionRule * cr = [[rule conditions] objectAtIndex:0];
			value = cr.valueOf;
			cr = nil;
		}
	}
		// rule.comment
	else if([[tableColumn identifier] isEqualToString:@"comment"]) {
		value = [rule comment];
	}
		//	NSLog(@"%s- [%04d] returning: %@", __PRETTY_FUNCTION__, __LINE__, value);
	return value;	
}

@end
