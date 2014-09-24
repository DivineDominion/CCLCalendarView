//
//  CCLDayCellView.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDayCellView.h"

@implementation CCLDayCellView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.backgroundColor)
    {
        [self.backgroundColor set];
        NSRectFill(self.bounds);
    }
    
    if (self.isSelected)
    {
        [self.selectionColor set];
        NSRectFill(self.bounds);
    }
    
    NSRect border = self.bounds;
    border.origin.x = NSMaxX(border) - 1;
    border.size.width = 1;
    [self.gridColor set];
    NSRectFill(border);
    
    if (self.isSelected)
    {
        NSInteger middleX = self.bounds.size.width / 2;
        
        NSRect triangleBounds = self.bounds;
        triangleBounds.size.width = triangleBounds.size.width / 2;
        triangleBounds.size.height = triangleBounds.size.height / 5;
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(middleX, NSMaxY(triangleBounds))];
        [path lineToPoint:NSMakePoint(middleX + triangleBounds.size.width / 2, NSMaxY(triangleBounds) - triangleBounds.size.height)];
        [path lineToPoint:NSMakePoint(NSMaxX(triangleBounds) - triangleBounds.size.width / 2, NSMaxY(triangleBounds) - triangleBounds.size.height)];
        
        [[NSColor whiteColor] set];
        [path fill];
    }
}

- (NSColor *)selectionColor
{
    if (!_selectionColor)
    {
        _selectionColor = [NSColor selectedControlColor];
    }
    
    return _selectionColor;
}

- (NSColor *)gridColor
{
    if (!_gridColor)
    {
        _gridColor = [NSColor gridColor];
    }
    
    return _gridColor;
}

- (void)select
{
    self.isSelected = YES;
    [self setNeedsDisplay:YES];
}

- (void)deselect
{
    self.isSelected = NO;
    [self setNeedsDisplay:YES];
}
@end
