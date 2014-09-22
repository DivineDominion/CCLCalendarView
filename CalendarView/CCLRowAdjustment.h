//
//  CCLRowAdjustment.h
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLProvidesTableData.h"

@class CCLDayCellSelection;

@interface CCLRowAdjustment : NSObject <CCLProvidesTableData>
@property (strong, readonly) CCLDayCellSelection *dayCellSelection;
@property (weak, readonly) id<CCLProvidesTableData> delegate;

+ (instancetype)rowAdjustmentWithDelegate:(id<CCLProvidesTableData>)delegate;
+ (instancetype)rowAdjustmentForSelection:(CCLDayCellSelection *)selection delegate:(id<CCLProvidesTableData>)delegate;

- (instancetype)initWithSelection:(CCLDayCellSelection *)selection delegate:(id<CCLProvidesTableData>)delegate;
@end
