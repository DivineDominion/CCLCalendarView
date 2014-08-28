//
//  CCLCalendarViewController.h
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CCLCalendarViewDelegate.h"

@class CCLDayCellSelection;
@class CCLDayDetailRowView;

@interface CCLCalendarViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CCLCalendarViewDelegate>
@property (weak) IBOutlet NSTableView *calendarTableView;
@property (weak) CCLDayDetailRowView *dayDetailRowView;
@property (strong) CCLDayCellSelection *cellSelection;
@end
