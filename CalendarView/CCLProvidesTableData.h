//
//  CCLProvidesTableData.h
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLTableDataTypes.h"

@protocol CCLProvidesTableData <NSObject>
/// Number of rows, with +1 for active selection.
- (NSUInteger)numberOfRows;
- (CCLRowViewType)rowViewTypeForRow:(NSUInteger)row;
- (CCLCellType)cellTypeForColumn:(NSUInteger)column row:(NSUInteger)row;
- (id)objectValueForColumn:(NSInteger)column row:(NSInteger)row;
- (id)objectValueForRow:(NSInteger)row;
- (NSString *)monthNameForTableView:(NSTableView *)tableView row:(NSInteger)row;
@end
