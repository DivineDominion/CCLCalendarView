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

- (NSUInteger)monthIndexOfRow:(NSUInteger)row
{
#warning stub TODO next
    return 0;
}
@end
