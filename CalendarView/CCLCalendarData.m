//
//  CCLCalendarData.m
//  CalendarView
//
//  Created by Christian Tietze on 09.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarData.h"
#import "CCLMonth.h"
#import "CCLMonths.h"
#import "CCLTitleRows.h"

NSInteger const kCLLNoDetailRow = -1;

@interface CCLCalendarData ()
@property (assign, readwrite) NSInteger detailRow;
@end

@implementation CCLCalendarData

+ (instancetype)calendarDataForMonths:(CCLMonths *)months
{
    return [[self alloc] initWithMonths:months];
}

- (instancetype)initWithMonths:(CCLMonths *)months
{
    NSParameterAssert(months);
    self = [super init];
    
    if (self)
    {
        _detailRow = kCLLNoDetailRow;
        _months = months;
        _titleRows = [CCLTitleRows titleRowsForMonths:months];
    }
    
    return self;
}

#pragma mark Row calculation

- (CCLMonth *)monthForRow:(NSUInteger)row
{
    [self adjustRowAccordingToDetailRow:&row];
    [self guardRowBoundsForRow:row];
    
    NSUInteger monthIndex = [self.titleRows monthIndexOfRow:row];
    CCLMonth *month = [self.months monthAtIndex:monthIndex];
    return month;
}

- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row
{
    if ([self hasDayDetailRowInRow:row])
    {
        return CCLRowViewTypeDayDetail;
    }
    
    [self adjustRowAccordingToDetailRow:&row];
    [self guardRowBoundsForRow:row];
    
    if ([self.titleRows containsRow:row])
    {
        return CCLRowViewTypeMonth;
    }
    
    return CCLRowViewTypeWeek;
}

- (void)guardRowBoundsForRow:(NSUInteger)row
{
    NSUInteger rowCount = [self rowCount];
    if (row <= rowCount)
    {
        return;
    }
    
    NSString *reason = [NSString stringWithFormat:@"row %lu is out of bounds (max: %lu)", row, rowCount];
    @throw [NSException exceptionWithName:NSRangeException reason:reason userInfo:nil];
}

// TODO move adjustment of row indexes out to make CalendarData stateless
- (void)adjustRowAccordingToDetailRow:(NSUInteger *)row
{
    if ([self hasDayDetailRow])
    {
        if (self.detailRow < *row)
        {
            *row = *row - 1;
        }
    }
}

- (NSUInteger)rowCount
{
    return [self.titleRows rowLimit];
}

- (NSUInteger)numberOfRows
{
    NSUInteger rowCount = [self rowCount];
    
    if ([self hasDayDetailRow])
    {
        rowCount++;
    }
    
    return rowCount;
}

#pragma mark Cell Calculation

- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row
{
    CCLRowViewType rowViewType = [self rowViewTypeForRow:row];
    
    if (rowViewType == CCLRowViewTypeMonth)
    {
        return CCLCellTypeMonth;
    }
    
    if (rowViewType == CCLRowViewTypeDayDetail)
    {
        return CCLCellTypeDayDetail;
    }
    
    if (rowViewType != CCLRowViewTypeWeek)
    {
        return CCLCellTypeUndefined;
    }
    
    if ([self containsDayForColumn:column row:row])
    {
        return CCLCellTypeDay;
    }
    
    //    CCLCellTypeBlank
    //    CCLCellTypeBlankLast
    //    CCLCellTypeWeekend
    
    return CCLCellTypeUndefined;
}

- (BOOL)containsDayForColumn:(NSUInteger)column row:(NSUInteger)row
{
#warning stub
    return YES;
}

#pragma mark -
#pragma mark Toggle Detail Row

- (void)insertDayDetailRowBelow:(NSUInteger)row
{
    [self guardRowBoundsForRow:row];
    
    self.detailRow = row + 1;
}

- (void)removeDayDetailRow
{
    self.detailRow = kCLLNoDetailRow;
}

- (BOOL)hasDayDetailRow
{
    return self.detailRow != kCLLNoDetailRow;
}

- (BOOL)hasDayDetailRowInRow:(NSUInteger)row
{
    if (![self hasDayDetailRow])
    {
        return NO;
    }
    
    return self.detailRow == row;
}
@end
