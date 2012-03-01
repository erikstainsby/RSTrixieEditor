//
//  RSTrixieTableDelegate.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-29.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGenericTableController.h"

@interface RSTrixieTableDelegate : GCGenericTableController

- (id) tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (id)				newContentObjectForTableController:(GCGenericTableController*) cllr;


@end
