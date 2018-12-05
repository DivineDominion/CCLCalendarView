//
//  CCLBorderedCellView.m
//  CalendarView
//
//  Created by Christian Tietze on 14.10.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLBorderedCellView.h"

@implementation CCLBorderedCellView

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
    
    [self drawBackground];
    [self drawBorder];
}

- (void)drawBackground
{
    // should be implemented in sub-class
}

- (void)drawBorder
{
    NSRect border = self.bounds;
    border.origin.x = NSMaxX(border) - 1;
    border.size.width = 1;
    [self.gridColor set];
    NSRectFill(border);
}

- (NSColor *)gridColor
{
    if (!_gridColor)
    {
        _gridColor = [NSColor gridColor];
    }
    
    return _gridColor;
}

- (NSColor *)backgroundColor
{
    if (_backgroundColor)
    {
        _backgroundColor = [NSColor controlBackgroundColor];
    }
    
    return _backgroundColor;
}
@end
