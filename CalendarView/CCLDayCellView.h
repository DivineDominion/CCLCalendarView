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
@property (copy) NSColor *backgroundColor;
@property (nonatomic, copy) NSColor *selectionColor;
@property (nonatomic, copy) NSColor *gridColor;
@property (readonly) NSTableView *tableView;

- (void)select;
- (void)deselect;
@end
