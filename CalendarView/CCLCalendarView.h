//
//  CCLCalendarView.h
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CCLCalendarViewDelegate;

@interface CCLCalendarView : NSTableView
@property (assign) NSInteger selectedRowIndex;

@property (weak) IBOutlet id<CCLCalendarViewDelegate> calendarViewDelegate;
@end
