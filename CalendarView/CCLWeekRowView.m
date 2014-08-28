//
//  CCLWeekRowView.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLWeekRowView.h"

@implementation CCLWeekRowView

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

- (void)drawSeparatorInRect:(NSRect)dirtyRect
{
    if (self.isGroupRowStyle)
    {
        return;
    }
    
    NSRect separatorRect = self.bounds;
    separatorRect.origin.y = NSMaxY(separatorRect) - 1;
    separatorRect.size.height = 2;
    
    [[NSColor lightGrayColor] set];
    NSRectFill(separatorRect);
}

@end
