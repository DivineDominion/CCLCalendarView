//
//  CCLCalendarView.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLCalendarView.h"
#import "CCLCalendarViewDelegate.h"
#import "CCLDayDetailRowView.h"

@implementation CCLCalendarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event
{
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger selectedRowIndex = [self rowAtPoint:point];
    NSInteger selectedColumnIndex = [self columnAtPoint:point];
    
    if ([self.calendarViewDelegate respondsToSelector:@selector(tableView:didSelectCellViewAtRow:column:)])
    {
        [self.calendarViewDelegate tableView:self didSelectCellViewAtRow:selectedRowIndex column:selectedColumnIndex];
    }
    
    [super mouseDown:event];
}

@end
