//
//  CCLAppDelegate.h
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CCLDisplayCalendar;
@protocol CCLHandlesDaySelection;
@protocol CCLProvidesCalendarObjects;

@interface CCLAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) id<CCLHandlesDaySelection, CCLProvidesCalendarObjects> calendarDelegate;
@property (strong) CCLDisplayCalendar *displayCalendar;

@end
