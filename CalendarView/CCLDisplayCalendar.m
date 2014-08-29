//
//  CCLDisplayCalendar.m
//  CalendarView
//
//  Created by Christian Tietze on 29.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDisplayCalendar.h"
#import "CCLCalendarViewController.h"

@implementation CCLDisplayCalendar

+ (instancetype)displayCalendarWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler
{
    return [[self alloc] initWithObjectProvider:objectProvider selectionHandler:selectionHandler];
}

- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler
{
    self = [super init];
    
    if (self)
    {
        _calendarViewController = [CCLCalendarViewController calendarViewController];
        _calendarViewController.objectProvider = objectProvider;
        _calendarViewController.eventHandler = selectionHandler;
    }
    
    return self;
}

#pragma mark -

- (void)displayInView:(NSView *)containerView
{
    NSParameterAssert(containerView);
    
    NSView *calendarView = self.calendarViewController.view;
    [calendarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView addSubview:self.calendarViewController.view];
    
    // Width constraint, 100% of parent view width
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:calendarView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:containerView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0
                                                               constant:0]];
    
    
    // Height constraint, 100% of parent view height
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:calendarView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:containerView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0]];
}

@end