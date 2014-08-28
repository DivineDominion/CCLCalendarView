//
//  CCLDayCellView.h
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCLDayCellView : NSTableCellView
@property (assign) BOOL isSelected;
- (void)select;
- (void)deselect;
@end
