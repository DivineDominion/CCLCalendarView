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
@property (assign, readonly) NSInteger row;
@property (assign, readonly) NSInteger column;
@property (nonatomic, strong, readonly) id objectValue;

+ (instancetype)dayCellSelection:(CCLDayCellView *)selectedView atRow:(NSInteger)row column:(NSInteger)column;
- (instancetype)initWithDayCellView:(CCLDayCellView *)selectedView row:(NSInteger)row column:(NSInteger)column;
@end
