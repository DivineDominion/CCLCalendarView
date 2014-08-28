//
//  CCLCalendarViewController.h
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CCLCalendarViewDelegate.h"

@class CCLDayCellView;

@interface CCLCalendarViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CCLCalendarViewDelegate>
@property (weak) IBOutlet NSTableView *calendarTableView;
@property (strong) CCLDayCellView *selectedView;
@end
