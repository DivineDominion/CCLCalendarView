//
//  CCLCellDayTranslation.h
//  CalendarView
//
//  Created by Christian Tietze on 23.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLDayLocator;
@class CCLCalendarData;

@interface CCLCellDayTranslation : NSObject
@property (strong, readonly) CCLCalendarData *calendarData;

+ (instancetype)cellDayTranslationFor:(CCLCalendarData *)calendarData;
- (instancetype)initWithCalendarData:(CCLCalendarData *)calendarData;

- (CCLDayLocator *)dayLocatorForColumn:(NSUInteger)column row:(NSUInteger)row;
@end
