//
//  CCLBorderedCellView.h
//  CalendarView
//
//  Created by Christian Tietze on 14.10.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCLBorderedCellView : NSTableCellView
@property (nonatomic, copy) NSColor *gridColor;
@property (nonatomic, copy) NSColor *backgroundColor;

- (void)drawBackground;
@end
