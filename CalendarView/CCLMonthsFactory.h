//
//  CCLMonthsFactory.h
//  CalendarView
//
//  Created by Christian Tietze on 05.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLMonths;
@class CCLDateRange;

@interface CCLMonthsFactory : NSObject
+ (instancetype)monthsFactory;

- (CCLMonths *)monthsInDateRange:(CCLDateRange *)dateRange;
@end
