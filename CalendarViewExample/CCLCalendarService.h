//
//  CCLCalendarService.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLHandlesDaySelection.h"
#import "CCLProvidesCalendarObjects.h"
#import "CCLProvidesDetailView.h"

@interface CCLCalendarService : NSObject <CCLHandlesDaySelection, CCLProvidesCalendarObjects, CCLProvidesDetailView>
@property (nonatomic, strong, readwrite, nonnull) NSDateFormatter *formatter;
@end
