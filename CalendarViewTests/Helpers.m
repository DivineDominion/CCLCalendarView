//
//  Helpers.m
//  CalendarViewTests
//
//  Created by Christian on 11.06.19.
//  Copyright © 2019 Christian Tietze. All rights reserved.
//

#import "Helpers.h"
#import "CTKCalendarSupplier.h"

@implementation Helper

+ (NSDate *)dateWithString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[CTKCalendarSupplier sharedInstance] autoupdatingCalendar];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZZ";
    return [formatter dateFromString:string];
}

@end

