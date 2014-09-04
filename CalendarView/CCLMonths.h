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
+ (instancetype)monthsFromArray:(NSArray *)array;
- (instancetype)initWithArray:(NSArray *)array;

- (CCLMonth *)monthAtIndex:(NSUInteger)index;
@end
