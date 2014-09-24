//
//  CCLDayCellSelection.h
//  CalendarView
//
//  Created by Christian Tietze on 28.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLDayCellView;

@interface CCLDayCellSelection : NSObject
@property (strong, readonly) CCLDayCellView *selectedView;
@property (assign, readonly) NSInteger row;
@property (assign, readonly) NSInteger column;

+ (instancetype)dayCellSelection:(CCLDayCellView *)selectedView atRow:(NSInteger)row column:(NSInteger)column;
- (instancetype)initWithDayCellView:(CCLDayCellView *)selectedView row:(NSInteger)row column:(NSInteger)column;

- (void)deselectCell;
- (id)objectValue;
@end
