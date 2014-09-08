//
//  CCLMonths.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLMonths.h"

#import "CTWCalendarSupplier.h"

#import "CCLMonth.h"

@interface CCLMonths ()
@property (copy) NSArray *months;
@end

@implementation CCLMonths

+ (instancetype)monthsFromArray:(NSArray *)array
{
    return [[self alloc] initWithArray:array];
}

- (instancetype)init
{
    return [self initWithArray:nil];
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    
    if (self)
    {
        [[self class] guardMonthsArray:array];
        
        _months = [array copy];
    }
    
    return self;
}

+ (void)guardMonthsArray:(NSArray *)array
{
    if (!array)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"array required" userInfo:nil];
    }
    
    if (array.count == 0)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"non-empty array required" userInfo:nil];
    }
    
    [self guardMonthConsecutivity:array];
}

+ (void)guardMonthConsecutivity:(NSArray *)array
{
    NSCalendar *calendar = [[CTWCalendarSupplier calendarSupplier] autoupdatingCalendar];
    NSDateComponents *monthInterval = [[NSDateComponents alloc] init];
    monthInterval.month = 1;
    
    __block NSDate *expectedMonthDate;
    
    [array enumerateObjectsUsingBlock:^(CCLMonth *month, NSUInteger index, BOOL *stop) {
        
        if (![month isKindOfClass:[self memberType]])
        {
            NSString *reason = [NSString stringWithFormat:@"array element %lu is not a month object but a %@", index, [month class]];
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        }
        
        NSDate *thisDate = month.date;
        NSDate *nextMonthDate = [calendar dateByAddingComponents:monthInterval toDate:thisDate options:0];
        
        // Skip first entry
        if (index == 0)
        {
            expectedMonthDate = nextMonthDate;
            return;
        }
        
        NSDateComponents *thisComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:thisDate];
        NSDateComponents *expectedComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:expectedMonthDate];
        
        if ([thisComponents isEqualTo:expectedComponents])
        {
            expectedMonthDate = nextMonthDate;
            return;
        }

        NSString *reason = [NSString stringWithFormat:@"expected consecutive month to be around %@ but was off instead: %@", expectedMonthDate, thisDate];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }];
}

+ (Class)memberType
{
    return [CCLMonth class];
}

#pragma mark -
#pragma mark Accessing Months

- (CCLMonth *)monthAtIndex:(NSUInteger)index
{
    return self.months[index];
}

- (NSUInteger)count
{
    return self.months.count;
}

- (void)enumerateMonthsUsingBlock:(void (^)(CCLMonth *, NSUInteger, BOOL *))block
{
    [self.months enumerateObjectsUsingBlock:block];
}

- (CCLMonth *)firstMonth
{
    return [self.months firstObject];
}

- (CCLMonth *)lastMonth
{
    return [self.months lastObject];
}
@end
