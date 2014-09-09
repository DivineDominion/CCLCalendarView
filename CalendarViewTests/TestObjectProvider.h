//
//  TestObjectProvider.h
//  CalendarView
//
//  Created by Christian Tietze on 09.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLProvidesCalendarObjects.h"

@class CCLDateRange;

@interface TestObjectProvider : NSObject <CCLProvidesCalendarObjects>
@property (strong) CCLDateRange *dateRange;
- (instancetype)initWithDateRange:(CCLDateRange *)dateRange;
@end
