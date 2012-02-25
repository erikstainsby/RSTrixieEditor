//
//  RSAppDelegate.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSAppDelegate.h"

@implementation RSAppDelegate

	//@synthesize window = _window;

@synthesize editorController;
@synthesize tableController;
@synthesize browserController;
@synthesize prefsController;

- (id)init {
	self = [super init];
	if(self)
	{
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		
		editorController = [[RSTrixieEditor alloc] init];
		[[editorController window] makeKeyAndOrderFront:self];
		
		prefsController = [[PreferencesController alloc] init];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
}

- (IBAction) showEditorOrListing:(id)sender {
	
	if(0 == [sender selectedSegment]) {
		[self showBrowser:sender];
	}
	else if(1 == [sender selectedSegment]) {
		[self showListTable:sender];
	}
}

- (IBAction) showBrowser:(id)sender {
	if( nil == browserController ) {
		browserController = [[RSTrixieBrowser alloc] initWithEditor:editorController];
		[[browserController window] makeKeyAndOrderFront:self];
	}
	else {
		[[browserController window] makeKeyAndOrderFront:nil];
	}
}

- (IBAction) showEditor:(id)sender {
	[[editorController window] orderFront:nil];
}

- (IBAction) showListTable:(id)sender {
	
	if( nil == tableController ) {
		tableController = [[RSTrixieTable alloc] init];
	}
	[[tableController window] orderFront:nil];
}

- (IBAction) showPreferences:(id)sender {
	[[prefsController window] makeKeyAndOrderFront:nil];
}


@end