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
@protocol CCLHandlesDaySelection;
@protocol CCLProvidesCalendarObjects;

extern NSString * const kCCLCalendarViewControllerNibName;

@interface CCLCalendarViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CCLCalendarViewDelegate>
@property (weak) id<CCLHandlesDaySelection> eventHandler;
@property (weak) id<CCLProvidesCalendarObjects> objectProvider;

@property (weak) IBOutlet NSTableView *calendarTableView;
@property (weak) CCLDayDetailRowView *dayDetailRowView;

@property (strong, readonly) CCLDayCellSelection *cellSelection;

+ (instancetype)calendarViewController;
@end
