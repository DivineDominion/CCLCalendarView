//
//  CCLCalendarViewModel.h
//  CalendarView
//
//  Created by Christian Tietze on 01.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLProvidesTableData.h"

#import "CCLCalendarData.h"

@protocol CCLProvidesCalendarObjects;
@class CCLDateRange;
@class CCLMonths;
@class CCLMonthsFactory;

@class CCLCellDayTranslation;

@interface CCLCalendarViewModel : NSObject <CCLProvidesTableData>
@property (nonatomic, strong) id<CCLProvidesCalendarObjects> objectProvider;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;

@property (strong) CCLCellDayTranslation *cellDayTranslation;

@property (strong) CCLCalendarData *calendarData;
@property (nonatomic, strong) CCLMonthsFactory *monthsFactory;

+ (instancetype)calendarVieweModelFrom:(id<CCLProvidesCalendarObjects>)objectProvider;
- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider;
@end
