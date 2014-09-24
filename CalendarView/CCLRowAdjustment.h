//
//  CCLRowAdjustment.h
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLProvidesTableData.h"
#import "CCLHandlesDayCellSelection.h"

@class CCLDayCellSelection;

@interface CCLRowAdjustment : NSObject <CCLProvidesTableData, CCLHandlesDayCellSelection>
@property (strong, readonly) CCLDayCellSelection *dayCellSelection;
@property (strong, readonly) id<CCLProvidesTableData> delegate;

+ (instancetype)rowAdjustmentForDelegate:(id<CCLProvidesTableData>)delegate;
- (instancetype)initWithDelegate:(id<CCLProvidesTableData>)delegate;
@end
