//
//  CCLDisplayCalendar.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLCalendarViewController;

@interface CCLDisplayCalendar : NSObject
@property (nonatomic, strong) CCLCalendarViewController *calendarViewController;

+ (instancetype)displayCalendar;

- (void)displayInView:(NSView *)containerView;
@end
