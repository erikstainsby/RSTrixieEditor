//
//  RSTrixieBrowser.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface RSTrixieBrowser : NSWindowController < NSComboBoxDataSource >

@property (retain) IBOutlet NSArray * resourceCache;
@property (retain) IBOutlet NSMutableArray * history;
@property (retain) IBOutlet NSComboBox * urlLocationBox;
@property (retain) IBOutlet WebView * webview;


#pragma mark - WebView delegate methods

- (IBAction) goForwardOrBack:(id)sender;
- (void) webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
- (void) webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame;


#pragma mark - NSComboBox datasource methods

- (NSInteger) numberOfItemsInComboBox:(NSComboBox *)aComboBox;
- (id) comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index;

@end
