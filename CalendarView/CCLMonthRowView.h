//
//  CCLMonthRowView.h
//  CalendarView
//
//  Created by Christian Tietze on 24.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCLMonthRowView : NSTableRowView
@property (nonatomic) NSString *monthName;
@property (weak) IBOutlet NSTextField *textField;
@end
