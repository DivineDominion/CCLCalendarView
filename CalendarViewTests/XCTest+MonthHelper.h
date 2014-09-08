//
//  XCTest+MonthHelper.h
//  CalendarView
//
//  Created by Christian Tietze on 08.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>

@class CCLMonth;

@interface XCTest (MonthHelper)
- (CCLMonth *)monthWithYear:(NSUInteger)year month:(NSUInteger)month;
- (CCLMonth *)monthWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
@end
