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
    
    if (self.isSelected)
    {
        [[NSColor blueColor] set];
    }
    else
    {
        [[NSColor whiteColor] set];
    }
    
    NSRectFill(self.bounds);
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
