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

@protocol CCLProvidesTableData;
@protocol CCLHandlesDayCellSelection;
@protocol CCLProvidesDetailView;

extern NSString * const kCCLCalendarViewControllerNibName;

@interface CCLCalendarViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CCLCalendarViewDelegate>
@property (weak) id<CCLHandlesDaySelection> eventHandler;
@property (weak) id<CCLProvidesDetailView> detailViewProvider;
@property (nonatomic, strong) id<CCLProvidesCalendarObjects> objectProvider;
@property (nonatomic, strong, readonly) id<CCLProvidesTableData> tableDataProvider;
@property (strong) id<CCLHandlesDayCellSelection> selectionDelegate;

@property (weak) IBOutlet NSTableView *calendarTableView;
@property (weak) CCLDayDetailRowView *dayDetailRowView;
@property (assign, readonly) BOOL showsAllWeekColumn;

+ (instancetype)calendarViewController;

- (void)reload;
@end
