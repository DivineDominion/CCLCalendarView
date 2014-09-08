//
//  CCLMonths.h
//  CalendarView
//
//  Created by Christian Tietze on 02.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLMonth;

@interface CCLMonths : NSObject
@property (readonly) NSUInteger count;

+ (instancetype)monthsFromArray:(NSArray *)array;
- (instancetype)initWithArray:(NSArray *)array;

- (CCLMonth *)firstMonth;
- (CCLMonth *)monthAtIndex:(NSUInteger)index;
- (void)enumerateMonthsUsingBlock:(void (^)(CCLMonth *month, NSUInteger index, BOOL *stop))block;
- (CCLMonth *)lastMonth;

@end
