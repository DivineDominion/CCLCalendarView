//
//  CCLHandlesDaySelection.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLCalendarViewController;

@protocol CCLHandlesDaySelection <NSObject>
@optional
- (void)calendarViewController:(CCLCalendarViewController *)calendarViewController didSelectCellWithObjectValue:(id)objectValue;

- (void)calendarViewControllerDidAddDetailView:(CCLCalendarViewController *)calendarViewController;
- (void)calendarViewControllerWillRemoveDetailView:(CCLCalendarViewController *)calendarViewController;
- (void)calendarViewControllerDidRemoveDetailView:(CCLCalendarViewController *)calendarViewController;
@end
