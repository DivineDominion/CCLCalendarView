//
//  CCLSelectsDayCells.h
//  CalendarView
//
//  Created by Christian Tietze on 09.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCLSelectsDayCells <NSObject>
- (BOOL)hasSelectedDayCell;

/// @returns Returns the table row index of the current selection or @p -1 if nothing is selected.
- (NSInteger)cellSelectionRow;
@end
