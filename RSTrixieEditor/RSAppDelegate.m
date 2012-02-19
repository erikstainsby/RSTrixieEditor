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
@synthesize browserController;

- (id)init {
	if(nil!=(self=[super init]))
	{
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		
		editorController = [[RSTrixieEditor alloc] init];
		[[editorController window] makeKeyAndOrderFront:self];
		
		browserController = [[RSTrixieBrowser alloc] init];
		[[browserController window] makeKeyAndOrderFront:self];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

@end
