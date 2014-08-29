//
//  CCLAppDelegate.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLAppDelegate.h"
#import "CCLDisplayCalendar.h"

@implementation CCLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.displayCalendar = [CCLDisplayCalendar displayCalendar];
    [self.displayCalendar displayInView:self.window.contentView];
}

@end
