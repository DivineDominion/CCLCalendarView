//
//  CCLHandleDaySelection.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLCalendarViewController;

@protocol CCLHandlesDaySelection <NSObject>
@required
- (NSView *)detailViewForObjectValue:(id)objectValue;

@optional
- (void)calendarViewController:(CCLCalendarViewController *)calendarViewController didSelectCellWithObjectValue:(id)objectValue;
@end
