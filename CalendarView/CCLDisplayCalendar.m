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

+ (instancetype)displayCalendarWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider detailViewProvider:(id<CCLProvidesDetailView>)detailViewProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler
{
    return [[self alloc] initWithObjectProvider:objectProvider detailViewProvider:detailViewProvider selectionHandler:selectionHandler];
}

- (instancetype)init
{
    return [self initWithObjectProvider:nil detailViewProvider:nil selectionHandler:nil];
}
- (instancetype)initWithObjectProvider:(id<CCLProvidesCalendarObjects>)objectProvider detailViewProvider:(id<CCLProvidesDetailView>)detailViewProvider selectionHandler:(id<CCLHandlesDaySelection>)selectionHandler
{
    NSParameterAssert(objectProvider);
    NSParameterAssert(detailViewProvider);
    
    self = [super init];
    
    if (self)
    {
        _calendarViewController = [CCLCalendarViewController calendarViewController];
        _calendarViewController.objectProvider = objectProvider;
        _calendarViewController.detailViewProvider = detailViewProvider;
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
