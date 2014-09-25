//
//  TestCalendarSupplier.h
//  CalendarView
//
//  Created by Christian Tietze on 05.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTWCalendarSupplier.h"

@interface TestCalendarSupplier : CTWCalendarSupplier
@property (strong) NSCalendar *testCalender;
@property (strong) NSLocale *testLocale;

+ (instancetype)unifiedGregorianCalendarSupplier;
@end
