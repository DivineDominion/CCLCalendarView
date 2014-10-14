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
@protocol CCLProvidesDetailView;

@interface CCLDisplayCalendar : NSObject
@property (strong, readonly) CCLCalendarViewController *calendarViewController;

+ (instancetype)displayCalendarWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider detailViewProvider:(id<CCLProvidesDetailView>)detailViewProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler;
- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider detailViewProvider:(id<CCLProvidesDetailView>)detailViewProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler;

- (void)displayInView:(NSView *)containerView;
@end
