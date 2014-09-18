//
//  CCLHandlesCellSelection.h
//  CalendarView
//
//  Created by Christian Tietze on 18.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLDayCellSelection;

@protocol CCLHandlesCellSelection <NSObject>
- (void)controllerDidSelectCell:(CCLDayCellSelection *)selection;
- (void)controllerDidDeselectCell;
- (CCLDayCellSelection *)cellSelection;
- (BOOL)hasCellSelection;
- (NSUInteger)cellSelectionRow;
@end
