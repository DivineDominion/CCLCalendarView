//
//  CCLDisplayCalendar.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLCalendarViewController;
@protocol CCLHandlesDaySelection;
@protocol CCLProvidesCalendarObjects;

@interface CCLDisplayCalendar : NSObject
@property (strong, readonly) CCLCalendarViewController *calendarViewController;

+ (instancetype)displayCalendarWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler;
- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler;

- (void)displayInView:(NSView *)containerView;
@end
