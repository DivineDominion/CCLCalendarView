//
//  CCLCalendarService.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLHandleDaySelection.h"
#import "CCLProvidesCalendarObjects.h"

@interface CCLCalendarService : NSObject <CCLHandlesDaySelection, CCLProvidesCalendarObjects>

@end
