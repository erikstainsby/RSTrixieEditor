//
//  RSTrixieBrowser.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <RSTrixiePlugin/RSTrixieRule.h>
#import "RSTrixieEditor.h"

@interface RSTrixieBrowser : NSWindowController < NSComboBoxDataSource, NSComboBoxDelegate >
{
	BOOL _hasJQuery;
	BOOL _hasJQueryUI;
}


@property (retain) NSArray * resourceCache;
@property (retain) NSMutableArray * history;
@property (retain) IBOutlet NSComboBox * urlLocationBox;
@property (retain) IBOutlet WebView * webview;
@property (retain) IBOutlet NSDictionary * pageDict;

@property (retain) RSTrixieEditor * editor;

- (id)initWithEditor:(RSTrixieEditor*)trixie;

#pragma mark - WebView delegate methods

- (IBAction) goForwardOrBack:(id)sender;
- (void) webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
- (void) webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame;


#pragma mark - NSComboBox datasource methods

- (NSInteger) numberOfItemsInComboBox:(NSComboBox *)aComboBox;
- (id) comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index;


#pragma mark - WebUIDelegate methods

- (void)webView:(WebView *)sender makeFirstResponder:(NSResponder *)responder;
	//- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags;
- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems;


#pragma mark - relay settings to editorController

- (IBAction) quickSetActionSelector:(id)sender;
- (IBAction) quickSetReactionSelector:(id)sender;
- (IBAction) quickSetConditionSelector:(id)sender;

#pragma mark - Receive instruction to reload html

- (IBAction) injectScript:(id)sender;


@end
