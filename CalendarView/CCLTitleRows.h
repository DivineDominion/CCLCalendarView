//
//  CCLTitleRows.h
//  CalendarView
//
//  Created by Christian Tietze on 08.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLMonths;

@interface CCLTitleRows : NSObject
@property (copy, readonly) NSArray *titleRows;

+ (instancetype)titleRowsForMonths:(CCLMonths *)months;
- (instancetype)initWithMonths:(CCLMonths *)months;

- (BOOL)containsRow:(NSUInteger)row;
- (NSUInteger)monthIndexOfRow:(NSUInteger)row;

/// The amount of rows acceptable according to the month-related information.
/// Is the sum of the last month's week count and its own row index.
- (NSUInteger)rowLimit;
@end
