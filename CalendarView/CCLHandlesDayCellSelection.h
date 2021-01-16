//
//  CCLHandlesDayCellSelection.h
//  CalendarView
//
//  Created by Christian Tietze on 18.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLDayCellSelection;
@class CCLDayCellView;

@protocol CCLHandlesDayCellSelection <NSObject>
- (void)controllerDidSelectDayCell:(CCLDayCellSelection *)selection;
- (void)controllerDidDeselectDayCell;

- (CCLDayCellSelection *)dayCellSelection;
- (id)dayCellSelectionObjectValue;

- (BOOL)hasDayCellSelection;
- (NSUInteger)dayCellSelectionRow;
- (NSUInteger)dayCellSelectionColumn;

- (void)configureDayCellView:(CCLDayCellView *)dayCellView row:(NSUInteger)row column:(NSUInteger)column;
@end
