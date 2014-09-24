//
//  CCLDayCellSelection.m
//  CalendarView
//
//  Created by Christian Tietze on 28.08.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CCLDayCellSelection.h"
#import "CCLDayCellView.h"

@implementation CCLDayCellSelection
+ (instancetype)dayCellSelection:(CCLDayCellView *)selectedView atRow:(NSInteger)row column:(NSInteger)column;
{
    return [[self alloc] initWithDayCellView:selectedView row:row column:column];
}

- (instancetype)init
{
    // TODO remove possibility to use negative values
    return [self initWithDayCellView:nil row:-1 column:-1];
}

- (instancetype)initWithDayCellView:(CCLDayCellView *)selectedView row:(NSInteger)row column:(NSInteger)column;
{
    NSParameterAssert(selectedView);
    
    self = [super init];
    
    if (self)
    {
        _selectedView = selectedView;
        [_selectedView select];
        
        _row = row;
        _column = column;
    }
    
    return self;
}

- (void)deselectCell
{
    [self.selectedView deselect];
}

- (id)objectValue
{
    return self.selectedView.objectValue;
}
@end
