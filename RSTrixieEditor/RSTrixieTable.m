//
//  RSTrixieTable.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-24.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixieTable.h"

@interface RSTrixieTable ()

@end

@implementation RSTrixieTable

@synthesize rules = _rules;
@synthesize tableView;

- (id)init
{
    self = [super initWithWindowNibName:@"RSTrixieTable" owner:self];
    if (self) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		
		_rules = [[NSMutableArray alloc] init];
		
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendRule:) name:nnRSTrixieStoreNewRuleNotification object:nil];
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	NSInteger ret = 0;
	if([_rules count]) ret = [_rules count];
	return ret;
}

- (id) tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		// rule.bindSelector
		// rule.bindEvent
		// rule.reactionSelector
		// rule.reactionBehaviour
		// rule.predicate
		// rule.comment
	
	RSTrixieRule * rule = [_rules objectAtIndex:row];
	return [rule valueForKey:[tableColumn identifier]];
	
}

- (void) appendRule:(NSNotification*)note {
	
		//NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [[note object] className]);
	RSTrixieRule * rule = [note object];
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [rule description]);
	[_rules addObject: rule];
	NSLog(@"%s- [%04d] count of rules: %lu", __PRETTY_FUNCTION__, __LINE__, [_rules count]);
	
	[tableView reloadData];
}

@end
