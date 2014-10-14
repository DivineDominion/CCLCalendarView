//
//  CCLProvidesDetailView.h
//  CalendarView
//
//  Created by Christian Tietze on 14.10.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCLProvidesDetailView <NSObject>
@required
/// Changes the behavior of the calendar: if the receiver returns
/// @p NO, cells without object value won't be selectable.
- (BOOL)allowsEmptyCellSelection;

- (NSView *)detailViewForObjectValue:(id)objectValue;

@optional
- (NSUInteger)heightOfDetailView;
@end
