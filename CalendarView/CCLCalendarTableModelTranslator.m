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

#import "CTWCalendarSupplier.h"

@interface CCLCalendarTableModelTranslator ()
@property (strong, readwrite) CCLMonths *months;
@end

@implementation CCLCalendarTableModelTranslator
+ (instancetype)calendarTableModelTranslatorFrom:(id<CCLProvidesCalendarObjects>)objectProvider
{
    return [[self alloc] initWithObjectProvider:objectProvider];
}

- (instancetype)init
{
    return [self initWithObjectProvider:nil];
}

- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider
{
    NSParameterAssert(objectProvider);
    
    self = [super init];
    
    if (self)
    {
        _objectProvider = objectProvider;
    }
    
    return self;
}

- (void)setObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider
{
    if (_objectProvider == objectProvider)
    {
        return;
    }
    
    _objectProvider = objectProvider;
    
    [self updateMonths];
}

- (void)updateMonths
{
    CCLDateRange *dateRange = self.objectProvider.dateRange;
    CCLMonths *months = [dateRange months];
    self.months = months;
}

#pragma mark -
#pragma mark Translation

- (id)objectValueForTableView:(NSTableView *)tableView column:(NSInteger)column row:(NSInteger)row
{
    NSInteger lastColumnIndex = tableView.tableColumns.count - 1;
    BOOL isLastColumn = (column == lastColumnIndex);
    
    id<CCLProvidesCalendarObjects> objectProvider = self.objectProvider;
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

- (NSUInteger)weeksOfMonthFromDateComponents:(NSDateComponents *)monthComponents
{
    NSCalendar *calendar = [self calendar];
    NSDate *date = [calendar dateFromComponents:monthComponents];
    NSAssert(date, @"month components not a valid date: %@", monthComponents);
    NSRange weekRange = [calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSUInteger weeksCount = weekRange.length;
    
    return weeksCount;
}

- (NSCalendar *)calendar
{
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
}

@end
