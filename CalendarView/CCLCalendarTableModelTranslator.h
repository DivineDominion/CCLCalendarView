//
//  CCLCalendarTableModelTranslator.h
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCLProvidesCalendarObjects;
@class CCLDateRange;

@interface CCLCalendarTableModelTranslator : NSObject
+ (instancetype)calendarTableModelTranslator;

- (id)objectValueForTableView:(NSTableView *)tableView objectProvider:(id<CCLProvidesCalendarObjects>)objectProvider column:(NSInteger)column row:(NSInteger)row;

- (NSUInteger)weeksOfMonthFromDateComponents:(NSDateComponents *)monthComponents;

@end
