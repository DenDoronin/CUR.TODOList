//
//  MyFriendsTests.m
//  MyFriendsTests
//
//  Created by Doronin Denis on 11/12/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DORTextValidatorEmail.h"
#import "DORTextValidatorNumeric.h"
#import "DOREmptyValidator.h"

@interface MyFriendsTests : XCTestCase

@end

@implementation MyFriendsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void) testEmptyValidator
{
    NSString *testString;
    BOOL      result;
    DOREmptyValidator *validator = [DOREmptyValidator new];
    
    testString = nil;
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"nil string should return NO");
    
    testString = @"";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"empty string should return NO");
    
    testString = @"test";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == YES, @"non empty string should return YES");
    
    
}

- (void) testEmailValidator
{
    NSString *testString;
    BOOL      result;
    DORTextValidatorEmail *validator = [DORTextValidatorEmail new];
    
    testString = nil;
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"nil string should return NO");
    
    testString = @"";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"empty string should return NO");
    
    testString = @"test";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"non valid email string should return NO");
    
    testString = @"test@test.com";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == YES, @" valid email string should return YES");
}

- (void) testPhoneValidator
{
    NSString *testString;
    BOOL      result;
    DORTextValidatorNumeric *validator = [DORTextValidatorNumeric new];
    
    testString = nil;
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"nil string should return NO");
    
    testString = @"";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"empty string should return NO");
    
    testString = @"test";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == NO, @"text string should return NO");
    
    testString = @"380507085116";
    result = [validator isValidInputValue:testString];
    XCTAssert(result == YES, @"string with set of characters {0123456789 +-()} should return YES");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
