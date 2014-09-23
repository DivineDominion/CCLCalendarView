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
    [self guardRowBoundsForRow:row];
    
    NSUInteger monthIndex = [self.titleRows monthIndexOfRow:row];
    CCLMonth *month = [self.months monthAtIndex:monthIndex];
    return month;
}

- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row
{
    [self guardRowBoundsForRow:row];
    
    if ([self.titleRows containsRow:row])
    {
        return CCLRowViewTypeMonth;
    }
    
    return CCLRowViewTypeWeek;
}

- (void)guardRowBoundsForRow:(NSUInteger)row
{
    NSUInteger rowCount = [self numberOfRows];
    if (row <= rowCount)
    {
        return;
    }
    
    NSString *reason = [NSString stringWithFormat:@"row %lu is out of bounds (max: %lu)", row, rowCount];
    @throw [NSException exceptionWithName:NSRangeException reason:reason userInfo:nil];
}

- (NSUInteger)numberOfRows
{
    return [self.titleRows rowLimit];
}

@end
