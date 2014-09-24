//
//  CCLTableDataTypes.h
//  CalendarView
//
//  Created by Christian Tietze on 22.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#ifndef CalendarView_CCLTableDateTypes_h
#define CalendarView_CCLTableDateTypes_h

typedef NS_ENUM(NSInteger, CCLRowViewType) {
    /// Denotes a missing calculation, really. Should never appear in production.
    CCLRowViewTypeUndefined = -1,
    
    CCLRowViewTypeMonth = 0,
    CCLRowViewTypeWeek,
    CCLRowViewTypeDayDetail
};

typedef NS_ENUM(NSInteger, CCLCellType) {
    /// Denotes a missing calculation, really. Should never appear in production.
    CCLCellTypeUndefined = -1,
    
    CCLCellTypeMonth = 0,
    CCLCellTypeDay,
    CCLCellTypeWeekend,
    
    CCLCellTypeDayDetail,
    
    /// Used when a weekday in a week is out of the calendar bounds.
    CCLCellTypeBlank
};

#endif
