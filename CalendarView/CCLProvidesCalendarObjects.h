//
//  CCLProvidesCalendarObjects.h
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCLProvidesCalendarObjects <NSObject>
- (id)objectValueForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
@end
