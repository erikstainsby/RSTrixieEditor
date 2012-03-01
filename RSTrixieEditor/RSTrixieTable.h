//
//  RSTrixieTable.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-24.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RSTrixiePlugin/RSTrixieRule.h>
#import "RSTrixieTableDelegate.h"

@interface RSTrixieTable : NSWindowController

@property (retain) IBOutlet RSTrixieTableDelegate * tableController;

- (void) appendRule:(NSNotification*) note;

@end
