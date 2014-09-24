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
    
    [self drawBackground];
    [self drawBorder];
    
    if (self.isSelected)
    {
        [self drawTriangle];
    }
}

- (void)drawBackground
{
    if (self.isSelected)
    {
        [self.selectionColor set];
        NSRectFill([self innerBounds]);
        return;
    }
    
    if (!self.isWeekend)
    {
        return;
    }
    
    [self.weekendColor set];
    NSRectFill([self innerBounds]);
}

- (NSRect)innerBounds
{
    // Leave 1px at the bottom for row separators
    NSRect innerBounds = self.bounds;
    innerBounds.size.height = NSMaxY(innerBounds) - 1;
    innerBounds.origin.y = 1;
    return innerBounds;
}

- (void)drawBorder
{
    NSRect border = self.bounds;
    border.origin.x = NSMaxX(border) - 1;
    border.size.width = 1;
    [self.gridColor set];
    NSRectFill(border);
}

- (void)drawTriangle
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


#pragma mark -
#pragma mark Interaction

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


#pragma mark - 
#pragma mark Color Configuration

- (NSColor *)weekendColor
{
    if (!_weekendColor)
    {
        _weekendColor = [NSColor colorWithWhite:.8 alpha:1.];
    }
    
    return _weekendColor;
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

@end
