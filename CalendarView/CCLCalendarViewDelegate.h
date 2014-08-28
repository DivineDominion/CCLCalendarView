//
//  CCLCalendarViewDelegate.h
//  CalendarView
//
//  Created by Christian Tietze on 26.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCLCalendarViewDelegate <NSObject>
- (void)tableView:(NSTableView *)tableView didSelectCellViewAtRow:(NSInteger)row column:(NSInteger)column;
@end
