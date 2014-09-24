//
//  CCLMonthRowView.m
//  CalendarView
//
//  Created by Christian Tietze on 24.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLMonthRowView.h"

@implementation CCLMonthRowView

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
