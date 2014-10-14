//
//  CCLDayCellView.h
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CCLBorderedCellView.h"

@interface CCLDayCellView : CCLBorderedCellView
@property (assign) BOOL isSelected;
@property (assign) BOOL isWeekend;
@property (nonatomic, copy) NSColor *selectionColor;
@property (nonatomic, copy) NSColor *weekendColor;
@property (readonly) NSTableView *tableView;

- (void)select;
- (void)deselect;
@end
