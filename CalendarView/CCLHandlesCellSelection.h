//
//  CCLHandlesCellSelection.h
//  CalendarView
//
//  Created by Christian Tietze on 18.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCLHandlesCellSelection <NSObject>
- (void)controllerDidSelectCellInRow:(NSUInteger)row;
- (void)controllerDidDeselectCell;
@end
