//
//  CCLBorderedRowView.m
//  CalendarView
//
//  Created by Christian Tietze on 14.10.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLBorderedRowView.h"

@implementation CCLBorderedRowView

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
    [self drawBottomGridLine];
}

- (void)drawBottomGridLine
{
    NSColor *gridColor = self.gridColor;
    NSRect separatorRect = self.bounds;
    separatorRect.origin.y = NSMaxY(separatorRect) - 1;
    separatorRect.size.height = 1;
    
    [gridColor set];
    
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
