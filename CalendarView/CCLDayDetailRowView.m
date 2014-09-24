//
//  CCLDayDetailRowView.m
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDayDetailRowView.h"

@implementation CCLDayDetailRowView

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

- (void)displayDetailView:(NSView *)subview
{
    [self.subviews enumerateObjectsUsingBlock:^(NSView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
    
    NSView *containerView = self;
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView addSubview:subview];
    
    // Width constraint, 100% of parent view width
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:containerView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0
                                                               constant:0]];
    
    
    // Height constraint, 100% of parent view height
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:containerView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0]];
}
@end
