//
//  TestCalendarSupplier.h
//  CalendarView
//
//  Created by Christian Tietze on 05.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTKCalendarSupplier.h"

@interface TestCalendarSupplier : CTKCalendarSupplier
@property (strong) NSCalendar *testCalendar;
@property (strong) NSLocale *testLocale;

+ (instancetype)unifiedGregorianCalendarSupplier;
@end
