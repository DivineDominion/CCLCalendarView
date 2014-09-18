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

@class CCLCalendarTableModelTranslator;
@protocol CCLHandlesCellSelection;

extern NSString * const kCCLCalendarViewControllerNibName;

@interface CCLCalendarViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CCLCalendarViewDelegate>
@property (weak) id<CCLHandlesDaySelection> eventHandler;
@property (nonatomic, strong) id<CCLProvidesCalendarObjects> objectProvider;
@property (nonatomic, strong, readonly) CCLCalendarTableModelTranslator *tableModelTranslator;
@property (weak) id<CCLHandlesCellSelection> selectionDelegate;

@property (weak) IBOutlet NSTableView *calendarTableView;
@property (weak) CCLDayDetailRowView *dayDetailRowView;

+ (instancetype)calendarViewController;
@end
