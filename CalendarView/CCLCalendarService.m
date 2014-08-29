//
//  CCLCalendarService.m
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarService.h"

@interface CellObject : NSObject
@property (copy) NSNumber *day;
@property (copy) NSNumber *total;

+ (instancetype)cellObjectForDay:(NSUInteger)day total:(NSUInteger)total;
@end

@implementation CellObject
+ (instancetype)cellObjectForDay:(NSUInteger)day total:(NSUInteger)total
{
    CellObject *result = [[self alloc] init];
    result.day = @(day);
    result.total = @(total);
    return result;
}
@end

@implementation CCLCalendarService
- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return [CellObject cellObjectForDay:day total:1234];
}

- (void)calendarViewController:(CCLCalendarViewController *)calendarViewController didSelectCellWithObjectValue:(id)objectValue
{
    
}

- (NSView *)detailViewForObjectValue:(id)objectValue
{
    NSTextField *label = [[NSTextField alloc] init];
    label.stringValue = @"test";
    
    return label;
}
@end
