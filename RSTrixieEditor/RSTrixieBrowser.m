//
//  RSTrixieBrowser.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixieBrowser.h"

@implementation RSTrixieBrowser

#ifndef nnRSSWebviewFrameDidFinishLoad
#define nnRSSWebviewFrameDidFinishLoad @"nnRSSWebviewFrameDidFinishLoad"
#endif

@synthesize resourceCache;
@synthesize history;
@synthesize urlLocationBox;
@synthesize webview;

- (id)init
{
    self = [super initWithWindowNibName:@"RSTrixieBrowser" owner:self];
    if (self) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
    }
    return self;
}

- (void) webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame 
{
	if( [sender mainFrame] == frame )
	{
		resourceCache = [[[sender mainFrame] dataSource] subresources];
		[[NSNotificationCenter defaultCenter] postNotificationName:nnRSSWebviewFrameDidFinishLoad object:sender];
	}
}

- (IBAction) goForwardOrBack:(id)sender {
	if( [sender selectedSegment] == 0 && [webview canGoBack] ) 
	{
		[webview goBack];
	}
	else if( [sender selectedSegment] == 1 && [webview canGoForward] ) 
	{
		[webview goForward];
	}
	[urlLocationBox setStringValue:[webview mainFrameURL]];
	
	// update history
	WebHistoryItem * item = [[webview backForwardList] currentItem];
	if( ! [history containsObject:item]) {
		[history addObject:item];
	}
}

- (void) webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
	if( [[sender mainFrame] isEqual: frame] )
	{
		[[sender window] setTitle: title];
	}
}

#pragma mark - NSComboBox datasource methods 

- (NSInteger) numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [history count];
}

- (id) comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	return [[history objectAtIndex:index] URLString];
}

@end
