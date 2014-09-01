//
//  CCLCalendarTableModelTranslator.m
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarTableModelTranslator.h"
#import "CCLProvidesCalendarObjects.h"
#import "CCLDateRange.h"

@implementation CCLCalendarTableModelTranslator
+ (instancetype)calendarTableModelTranslator
{
    return [[self alloc] init];
}

- (id)objectValueForTableView:(NSTableView *)tableView objectProvider:(id<CCLProvidesCalendarObjects>)objectProvider column:(NSInteger)column row:(NSInteger)row
{
    NSInteger lastColumnIndex = tableView.tableColumns.count - 1;
    BOOL isLastColumn = (column == lastColumnIndex);
    
    CCLDateRange *dateRange = objectProvider.dateRange;
    NSDateComponents *startDateComponents = [dateRange startDateCalendarComponents];
    NSUInteger year = startDateComponents.year;
    
    if (isLastColumn)
    {
        if (![objectProvider respondsToSelector:@selector(objectValueForYear:week:)])
        {
            return nil;
        }
        NSUInteger week = startDateComponents.week;
        
        return [objectProvider objectValueForYear:year week:week];
    }
    
    NSUInteger month = startDateComponents.month;
    NSUInteger day = startDateComponents.day;
    
    return [objectProvider objectValueForYear:year month:month day:day];
}
@end
