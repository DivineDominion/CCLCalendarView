//
//  CCLCalendarViewModel.m
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarViewModel.h"
#import "CCLProvidesCalendarObjects.h"
#import "CCLDateRange.h"
#import "CCLMonthsFactory.h"
#import "CCLTitleRows.h"
#import "CCLMonths.h"
#import "CCLMonth.h"

#import "CCLCellDayTranslation.h"
#import "CCLDayLocator.h"

#import "CTWCalendarSupplier.h"

@interface CCLCalendarViewModel ()
@end

@implementation CCLCalendarViewModel
+ (instancetype)calendarVieweModelFrom:(id<CCLProvidesCalendarObjects>)objectProvider
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
        [self updateMonths];
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
    CCLMonthsFactory *monthsFactory = self.monthsFactory;
    CCLMonths *months = [monthsFactory monthsInDateRange:dateRange];
    CCLCalendarData *calendarData = [CCLCalendarData calendarDataForMonths:months];
    
    self.calendarData = calendarData;
    self.cellDayTranslation = [CCLCellDayTranslation cellDayTranslationFor:calendarData];
}

- (CCLMonthsFactory *)monthsFactory
{
    if (!_monthsFactory)
    {
        _monthsFactory = [CCLMonthsFactory monthsFactory];
    }
    
    return _monthsFactory;
}

- (NSCalendar *)calendar
{
    return [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
}

#pragma mark -
#pragma mark Translation

- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row
{
    return [self.calendarData rowViewTypeForRow:row];
}

- (NSUInteger)numberOfRows
{
    return [self.calendarData numberOfRows];
}

- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row
{
    CCLRowViewType rowViewType = [self rowViewTypeForRow:row];
    
    if (rowViewType == CCLRowViewTypeMonth || rowViewType == CCLRowViewTypeDayDetail)
    {
        return CCLCellTypeUndefined;
    }
        
    CCLCellDayTranslation *translation = self.cellDayTranslation;
    CCLDayLocator *dayLocator = [translation dayLocatorForColumn:column row:row];
    
    if ([dayLocator isOutsideDayRange])
    {
        return CCLCellTypeBlank;
    }
    
    if ([dayLocator isWeekend])
    {
        return CCLCellTypeWeekend;
    }
    
    return CCLCellTypeDay;
}

- (id)objectValueForTableView:(NSTableView *)tableView column:(NSInteger)column row:(NSInteger)row
{
    NSInteger lastColumnIndex = tableView.tableColumns.count - 1;
    BOOL isLastColumn = (column == lastColumnIndex);
    id<CCLProvidesCalendarObjects> objectProvider = self.objectProvider;
    CCLCellDayTranslation *translation = self.cellDayTranslation;
    CCLDayLocator *dayLocator = [translation dayLocatorForColumn:column row:row];
    NSDateComponents *dateComponents = [dayLocator dateComponents];
    NSUInteger year = dateComponents.year;
    
    if (isLastColumn)
    {
        if (![objectProvider respondsToSelector:@selector(objectValueForYear:week:)])
        {
            return nil;
        }
        
        NSUInteger week = dateComponents.weekOfYear;
        return [objectProvider objectValueForYear:year week:week];
    }
    
    NSUInteger month = dateComponents.month;
    NSUInteger day = dateComponents.day;
    
    return [objectProvider objectValueForYear:year month:month day:day];
}

- (NSString *)monthNameForTableView:(NSTableView *)tableView row:(NSInteger)row
{
    CCLMonth *month = [self.calendarData monthForRow:row];
    return month.name;
}

@end
