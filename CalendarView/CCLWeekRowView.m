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
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect
{
    [super drawBackgroundInRect:dirtyRect];
}

- (void)drawSeparatorInRect:(NSRect)dirtyRect
{
    if (self.isGroupRowStyle)
    {
        return;
    }
    
    [self drawGridLine];
}

- (void)drawGridLine
{
    NSRect separatorRect = self.bounds;
    separatorRect.origin.y = NSMaxY(separatorRect) - 1;
    separatorRect.size.height = 2;
    
    [self.gridColor set];
    NSRectFill(separatorRect);
}

- (NSColor *)gridColor
{
    if (!_gridColor)
    {
        _gridColor = [NSColor gridColor];
    }
    
    return _gridColor;
}

@end
