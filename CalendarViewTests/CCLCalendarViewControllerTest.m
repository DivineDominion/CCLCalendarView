//
//  CCLCalendarViewControllerTest.m
//  CalendarView
//
//  Created by Christian Tietze on 04.09.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestObjectProvider.h"

#import "CCLCalendarViewController.h"
#import "CCLCalendarTableModelTranslator.h"

@interface CCLCalendarViewControllerTest : XCTestCase

@end

@implementation CCLCalendarViewControllerTest
{
    CCLCalendarViewController *viewController;
}

- (void)setUp
{
    [super setUp];
    viewController = [CCLCalendarViewController calendarViewController];
    [viewController performSelector:@selector(loadView)];
}

- (void)tearDown
{
    viewController = nil;
    [super tearDown];
}

- (void)testView_IsLoaded
{
    XCTAssertNotNil(viewController.view, @"view should be loaded");
}

- (void)testInitially_DoesntHaveADataProvider
{
    XCTAssertNil(viewController.tableDataProvider, @"should not have a translator first");
}

- (void)testSettingObjectProvider_UpdatesTranslator
{
    TestObjectProvider *objectProvider = [[TestObjectProvider alloc] init];
    
    [viewController setObjectProvider:objectProvider];
    
    XCTAssertNotNil(viewController.tableDataProvider, @"should have set a translator");
    XCTAssertEqual([[(id)viewController.tableDataProvider delegate] objectProvider], objectProvider, @"translator should obtain object provider");
}

@end
