//
//  RSTrixieTable.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-24.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixieTable.h"

@interface RSTrixieTable ()

- (NSString *) despoolScript;

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


- (NSString *) despoolScript {
	
	NSString * 	script = @"/** RSTrixie injected script **/";
	
	for(RSTrixieRule * rule in [tableController content])
	{
		if( ! [[rule comment] isEqualToString:@""]) {
			script = [script stringByAppendingFormat:@"\n/** %@ **/\n", [rule comment]];
		}
		
		script = [script stringByAppendingFormat:@"$('%@').bind('%@',function(event,elem){\n",[[rule action] selector],[[rule action] event]];

		for(RSReactionRule * rr in [rule reactions]) 
		{
			script = [script stringByAppendingFormat:@"\t%@\n",[rr callback]];
		}
		
		for(RSConditionRule * cr in [rule conditions]) 
		{
			if(![[cr selector] isEqualToString:@""]) {
				script = [script stringByAppendingFormat:@"\t%@\n",[cr prerequisite]];
			}
		}
		script = [script stringByAppendingString:@"});\n"];
	}
	
	return script;
}



- (void) appendRule:(NSNotification*)note {
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	RSTrixieRule * rule = [note object];
	[tableController addObjectToContent:rule];
	
	NSString * script = [self despoolScript];
	[[NSNotificationCenter defaultCenter] postNotificationName:nnRSTrixieReloadJavascriptNotification object:script]; 

}

@end
