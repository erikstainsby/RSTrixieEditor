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
@synthesize pageDict;
@synthesize editor;

- (id)initWithEditor:(RSTrixieEditor*)trixie {

    self = [super initWithWindowNibName:@"RSTrixieBrowser" owner:self];
    if (self) {
		[self setEditor:trixie];
		[[webview menu] setAutoenablesItems:NO];
		[webview setMaintainsBackForwardList:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(injectScript:) name:nnRSTrixieReloadJavascriptNotification object:nil];
    }
    return self;
}

- (BOOL) scanCacheForResourceWithName:(NSString*)resourceName {

	for(WebResource * wr in resourceCache) {
		if( [[[wr URL] lastPathComponent] hasPrefix:resourceName] ) 
		{
			NSLog(@"%s- [%04d] identified resource: %@ in URL: %@", __PRETTY_FUNCTION__, __LINE__, resourceName, [[wr URL] path]);
			return YES;
		}
	}
	return NO;
}


- (void) webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	if( [sender mainFrame] == frame )
	{
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		resourceCache = [[[sender mainFrame] dataSource] subresources];
		
		_hasJQuery = [self scanCacheForResourceWithName:@"jquery"];
		_hasJQueryUI = [self scanCacheForResourceWithName:@"jqueryui"];
		_hasJQueryUI = [self scanCacheForResourceWithName:@"jquery-ui"];
		
		NSString * urlString = [webview mainFrameURL];
		
		DOMDocument * doc = [webview mainFrameDocument];
		NSString * doctype = [self doctypeString:[doc doctype]];
		
		DOMNode * html = [(DOMNodeList *)[doc getElementsByTagName:@"html"] item:0];
		NSString * htmlTag = [self selectorForDOMNode:html];
		
		DOMNodeList * list = [doc getElementsByTagName:@"head"];
		DOMHTMLElement * head = (DOMHTMLElement*)[list item:0]; 
		NSString * headString = [head innerHTML];
		
		list = [doc getElementsByTagName:@"body"];
		DOMNode * body = (DOMHTMLElement*)[list item:0]; 
		NSString * bodyTag = [self selectorForDOMNode:body];
		NSString * bodyString = [(DOMHTMLElement *)body innerHTML];
		
		pageDict = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"url",
							   doctype,@"doctype",
							   htmlTag,@"htmlTag",
							   headString,@"head",  
							   bodyTag,@"bodyTag",
							   bodyString,@"body", 
							   nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:nnRSSWebviewFrameDidFinishLoad object:pageDict];
		
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"doctype"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"htmlTag"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"head"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"bodyTag"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"body"]);
		
		
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

- (void) webView:(WebView*) sender makeFirstResponder:(NSResponder *)responder { 
	if( [responder respondsToSelector:@selector(acceptsFirstResponder:)] )
	{
		[responder becomeFirstResponder];
	}
}

- (NSString *) doctypeString:(DOMDocumentType*)doctype {
	NSString * string = @"<!doctype";
	
	if([[doctype name] length] > 0) string = [string stringByAppendingFormat:@" %@",[doctype name]];
	if([[doctype publicId] length] > 1) string = [string stringByAppendingFormat:@" \"%@\"",[doctype publicId]];
	if([[doctype systemId] length] > 1) string = [string stringByAppendingFormat:@" \"%@\"",[doctype systemId]];
	
	string = [string stringByAppendingString:@">"];
	
	return string;
}

- (NSString *) selectorForDOMNode:(DOMNode*)node {
	
	NSString * selector = @"";
	DOMElement * el = nil;
	if( [node nodeType] == DOM_ELEMENT_NODE) 
	{
		el = (DOMElement *)node;
	}
	else if( [node nodeType] == DOM_TEXT_NODE)  
	{
		el = [(DOMElement *)node parentElement];	
	}	
	if( el != nil ) {
		selector = [el tagName]; 
		if([el hasAttribute:@"id"]) {
			selector = [selector stringByAppendingFormat:@"#%@",[el getAttribute:@"id"]];
		}
		if( ! [[el className] isEqualToString:@""] ) {
				// classes may be multiple
			NSString * classes = [[[el className] componentsSeparatedByString:@" "] componentsJoinedByString:@"."];
			selector = [selector stringByAppendingFormat:@".%@",classes];
		}
		
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, selector );
	}
	return selector;
}

- (NSArray *)  webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems {
	
	NSString * nodeSelector = [self selectorForDOMNode:[element objectForKey:WebElementDOMNodeKey]];
	
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, nodeSelector);
	
	NSMenuItem * item1 = [[NSMenuItem alloc] initWithTitle:@"Set Action selector" 
													action:@selector(quickSetActionSelector:) 
											 keyEquivalent:@""];
	NSMenuItem * item2 = [[NSMenuItem alloc] initWithTitle:@"Set Reaction selector" 
													action:@selector(quickSetReactionSelector:) 
											 keyEquivalent:@""];
	NSMenuItem * item3 = [[NSMenuItem alloc] initWithTitle:@"Set Condition selector" 
													action:@selector(quickSetConditionSelector:) 
											 keyEquivalent:@""];
	
	if([[editor activeActionPlugin] hasSelectorField] ) {
		[item1 setTarget:self];
		[item1 setEnabled:YES];
		[item1 setRepresentedObject:nodeSelector];
	}
	else {
		[item1 setEnabled:NO];
	}
	if([[editor activeReactionPlugin] hasSelectorField]) {
		[item2 setTarget:self];
		[item2 setEnabled:YES];
		[item2 setRepresentedObject:nodeSelector];
	}
	else {
		[item2 setEnabled:NO];
	}
	if([[editor activeConditionPlugin] hasSelectorField]) {
		[item3 setTarget:self];
		[item3 setEnabled:YES];
		[item3 setRepresentedObject:nodeSelector];
	}
	else {
		[item3 setEnabled:NO];
	}
	
	
	NSMutableArray * myMenu = [NSMutableArray arrayWithObjects:item1,item2,item3,nil];
	return [myMenu arrayByAddingObjectsFromArray:defaultMenuItems];
}


#pragma mark - NSComboBox datasource methods 

- (NSInteger) numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [history count];
}

- (id) comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	return [[history objectAtIndex:index] URLString];
}


#pragma mark - relay settings to editorController

- (IBAction) quickSetActionSelector:(id)sender {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[editor setActionSelectorStringValue:[sender representedObject]];
}

- (IBAction) quickSetReactionSelector:(id)sender {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[editor setReactionSelectorStringValue:[sender representedObject]];
}

- (IBAction) quickSetConditionSelector:(id)sender {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[editor setConditionSelectorStringValue:[sender representedObject] ];
}


#pragma mark - Receive instruction to reload html, insert jQuery/-UI if required, and injecting the custom behaviours

- (void) injectScript:(NSNotification *) note {
	
	NSString * script = [note object];
	
	NSString * page = [pageDict valueForKey:@"doctype"];
	page = [page stringByAppendingFormat:@"\n<%@>\n<HEAD>\n",[pageDict valueForKey:@"htmlTag"]];
	
	if( ! _hasJQuery || ! _hasJQueryUI )
	{
		page = [page stringByAppendingString:@"<script id=\"Your Google API key\" type=\"text/javascript\""];
		page = [page stringByAppendingFormat:@" src=\"https://www.google.com/jsapi?key=%@\">", [[NSUserDefaults standardUserDefaults] valueForKey:@"googleAPIKey"]];
		page = [page stringByAppendingString:@"</script>\n"];
	}
	if( ! _hasJQuery )
	{
		page = [page stringByAppendingString:@"<script id=\"jquery-loader\" type=\"text/javascript\">"];
		page = [page stringByAppendingFormat:@"\tgoogle.load('jquery','%@');", [[NSUserDefaults standardUserDefaults] valueForKey:@"jqueryVersion"]];
		page = [page stringByAppendingString:@"</script>\n"];
	}
	if( ! _hasJQueryUI )
	{
		page = [page stringByAppendingString:@"<script id=\"jquery-ui-loader\">"];
		page = [page stringByAppendingFormat:@"\tgoogle.load('jquery-ui','%@');", [[NSUserDefaults standardUserDefaults] valueForKey:@"jqueryUIVersion"]];
		page = [page stringByAppendingString:@"</script>\n"];
	}
	
	page = [page stringByAppendingFormat:@"%@\n",[pageDict valueForKey:@"head"]];
	page = [page stringByAppendingString:@"</HEAD>\n"];
	page = [page stringByAppendingFormat:@"<%@>\n",[pageDict valueForKey:@"bodyTag"]];
	page = [page stringByAppendingFormat:@"%@\n",[pageDict valueForKey:@"body"]];
	
	page = [page stringByAppendingString:@"<!-- ** RSTrixie generated script ** -->\n"];
	page = [page stringByAppendingString:@"<script id=\"RSTrixieScript\" type=\"text/javascript\">\njQuery().ready(function($){\n"];
	
	page = [page stringByAppendingString:script];
	
	page = [page stringByAppendingString:@"</script>"];
	page = [page stringByAppendingString:@"</BODY>\n</HTML>\n"];
	
	[[webview mainFrame] loadHTMLString:page baseURL:[NSURL URLWithString:[webview mainFrameURL]]];
}

@end
