//
//  CCLTitleRows.m
//  CalendarView
//
//  Created by Christian Tietze on 08.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLTitleRows.h"
#import "CCLMonths.h"
#import "CCLMonth.h"

@interface CCLTitleRows ()
@property (copy, readwrite) NSArray *titleRows;
@property (assign) NSUInteger lastMonthBounds;
@end

@implementation CCLTitleRows
+ (instancetype)titleRowsForMonths:(CCLMonths *)months
{
    return [[self alloc] initWithMonths:months];
}

- (instancetype)init
{
    return [self initWithMonths:nil];
}

- (instancetype)initWithMonths:(CCLMonths *)months
{
    NSParameterAssert(months);
    self = [super init];
    
    if (self)
    {
        [self setupTitleRowsFor:months];
    }
    
    return self;
}

- (void)setupTitleRowsFor:(CCLMonths *)months
{
    __block NSUInteger row = 0;
    NSMutableArray *titleRows = [NSMutableArray arrayWithCapacity:months.count];
    
    [months enumerateMonthsUsingBlock:^(CCLMonth *month, NSUInteger idx, BOOL *stop) {
        
        [titleRows addObject:@(row)];
        
        row += [month weekCount]; // Amount of weeks in the month
        row++;                    // Next free title row
    }];
    
    self.titleRows = titleRows;
    self.lastMonthBounds = months.lastMonth.weekCount;
}

- (BOOL)containsRow:(NSUInteger)aRow
{
    NSArray *rows = self.titleRows;
    
    if (rows == nil || rows.count == 0)
    {
        return NO;
    }
    
    __block BOOL containsRow = NO;
    
    [rows enumerateObjectsUsingBlock:^(NSNumber *object, NSUInteger idx, BOOL *stop) {
        
        NSUInteger titleRow = [object unsignedIntegerValue];
        
        if (titleRow < aRow)
        {
            return;
        }
        
        // Equal or greater than aRow: stop enumerating to spare cycles
        *stop = YES;
        
        if (titleRow > aRow)
        {
            return;
        }
        
        containsRow = YES;
    }];
    
    return containsRow;
}

- (NSUInteger)lastRow
{
    return [self.titleRows.lastObject unsignedIntegerValue];
}

- (NSUInteger)monthIndexOfRow:(NSUInteger)aRow
{
    [self guardRowInsideMonthBounds:aRow];
    
    NSUInteger returnedIndex = 0;
    NSArray *rows = self.titleRows;
    
    for (NSUInteger index = 0; index < rows.count; index++)
    {
        NSUInteger titleRow = [rows[index] unsignedIntegerValue];
        
        if (titleRow <= aRow)
        {
            returnedIndex = index;
        }
    }
    
    return returnedIndex;
}

- (void)guardRowInsideMonthBounds:(NSUInteger)row
{
    NSUInteger lastMonthRow = [self.titleRows.lastObject unsignedIntegerValue];
    NSUInteger weekCount = self.lastMonthBounds;
    NSUInteger maximum = lastMonthRow + weekCount;
    
    if (row <= maximum)
    {
        return;
    }
    
    NSString *reason = [NSString stringWithFormat:@"row %lu is out of bounds for month index %lu + week count %lu (= %lu)", row, lastMonthRow, weekCount, maximum];
    @throw [NSException exceptionWithName:NSRangeException reason:reason userInfo:nil];
}
@end
