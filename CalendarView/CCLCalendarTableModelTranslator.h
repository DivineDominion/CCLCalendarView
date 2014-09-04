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
@class CCLMonths;

@interface CCLCalendarTableModelTranslator : NSObject
@property (nonatomic, strong) id<CCLProvidesCalendarObjects> objectProvider;
@property (strong, readonly) CCLMonths *months;

+ (instancetype)calendarTableModelTranslatorFrom:(id<CCLProvidesCalendarObjects>)objectProvider;
- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider;

- (id)objectValueForTableView:(NSTableView *)tableView column:(NSInteger)column row:(NSInteger)row;
- (NSUInteger)weeksOfMonthFromDateComponents:(NSDateComponents *)monthComponents;

@end
