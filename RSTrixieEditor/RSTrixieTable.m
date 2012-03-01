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

@synthesize tableController;

- (id)init
{
    self = [super initWithWindowNibName:@"RSTrixieTable" owner:self];
    if (self) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendRule:) name:nnRSTrixieStoreNewRuleNotification object:nil];
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
}


- (void) appendRule:(NSNotification*)note {
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	
	RSTrixieRule * rule = [note object];
	
	[tableController addObjectToContent:rule];
	
}

@end
