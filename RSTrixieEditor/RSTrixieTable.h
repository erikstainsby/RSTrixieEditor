//
//  RSTrixieTable.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-24.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RSTrixiePlugin/RSTrixieRule.h>

@interface RSTrixieTable : NSWindowController < NSTableViewDataSource >

@property (retain) IBOutlet NSMutableArray * rules;
@property (retain) IBOutlet NSTableView * tableView;

- (void) appendRule:(NSNotification*)note;


- (NSInteger) numberOfRowsInTableView:(NSTableView *)aTableView;
- (id) tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
