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
- (NSUInteger)lastRow;
@end
