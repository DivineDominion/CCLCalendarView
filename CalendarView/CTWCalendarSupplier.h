//
//  CTWCalendarSupplier.h
//  WordCounter
//
//  Created by Christian Tietze on 14.04.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTWCalendarSupplier : NSObject
+ (instancetype)calendarSupplier;
+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(CTWCalendarSupplier *)instance;
+ (void)resetSharedInstance;

- (NSCalendar *)autoupdatingCalendar;
- (NSLocale *)autoupdatingLocale;
@end
