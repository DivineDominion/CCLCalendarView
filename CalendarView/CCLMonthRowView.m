//
//  CCLMonthRowView.m
//  CalendarView
//
//  Created by Christian Tietze on 24.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLMonthRowView.h"

@implementation CCLMonthRowView

- (void)drawSeparatorInRect:(NSRect)dirtyRect
{
    // do not draw a separator
}

- (NSString *)monthName
{
    return self.textField.stringValue;
}

- (void)setMonthName:(NSString *)monthName
{
    if ([self.monthName isEqualToString:monthName])
    {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(monthName))];
    [self.textField setStringValue:monthName];
    [self didChangeValueForKey:NSStringFromSelector(@selector(monthName))];
}
@end
