//
//  CCLMonths.m
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLMonths.h"

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
    [array enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        
        if (![object isKindOfClass:[self memberType]])
        {
            NSString *reason = [NSString stringWithFormat:@"array element %lu is not a month object but a %@", index, [object class]];
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        }
        
#warning test consecutivity missing
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
@end
