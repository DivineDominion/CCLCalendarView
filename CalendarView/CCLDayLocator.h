//
//  CCLDayLocator.h
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLMonth;

@interface CCLDayLocator : NSObject
@property (strong, readonly) CCLMonth *month;
@property (assign, readonly) NSUInteger week;
@property (assign, readonly) NSUInteger weekday;

+ (instancetype)dayLocatorInMonth:(CCLMonth *)month week:(NSUInteger)week weekday:(NSUInteger)weekday;
- (instancetype)initWithMonth:(CCLMonth *)month week:(NSUInteger)week weekday:(NSUInteger)weekday;

- (BOOL)isOutsideDayRange;
- (BOOL)isWeekend;

- (NSDateComponents *)dateComponents;
@end
