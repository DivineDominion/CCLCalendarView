//
//  CCLAppDelegate.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLAppDelegate.h"
#import "CCLDisplayCalendar.h"
#import "CCLCalendarService.h"

@implementation CCLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.calendarDelegate = [[CCLCalendarService alloc] init];
    self.displayCalendar = [CCLDisplayCalendar displayCalendarWithObjectProvider:self.calendarDelegate detailViewProvider:self.calendarDelegate selectionHandler:self.calendarDelegate];
    [self.displayCalendar displayInView:self.window.contentView];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}
@end
