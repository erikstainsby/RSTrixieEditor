//
//  RSAppDelegate.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import <RSTrixiePlugin/RSTrixiePlugin.h>
#import "RSTrixieEditor.h"
#import "RSTrixieTable.h"
#import "RSTrixieBrowser.h"
#import "PreferencesController.h"

@interface RSAppDelegate : NSObject <NSApplicationDelegate>

	//@property (retain) IBOutlet NSWindow * window;
@property (retain) IBOutlet RSTrixieEditor * editorController;
@property (retain) IBOutlet RSTrixieTable * tableController;
@property (retain) IBOutlet RSTrixieBrowser * browserController;
@property (retain) IBOutlet PreferencesController * prefsController; 

- (IBAction) showBrowser:(id)sender;
- (IBAction) showEditor:(id)sender;
- (IBAction) showPreferences:(id)sender;
- (IBAction) showListTable:(id)sender;
- (IBAction) showEditorOrListing:(id)sender;


@end
