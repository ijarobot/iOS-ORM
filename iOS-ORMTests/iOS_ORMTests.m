//
//  iOS_ORMTests.m
//  iOS-ORMTests
//
//  Created by User on 13-7-14.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "iOS_ORMTests.h"

#import "UserDao.h"
#import "User.h"

@implementation iOS_ORMTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    UserDao *userDao = [[[UserDao alloc] init] autorelease];
    
    for (int x = 0; x < 20; x++) {
        User * user = [[[User alloc] init] autorelease];
        user.userID     = [NSString stringWithFormat:@"3243343%d",x];
        user.userName   = [NSString stringWithFormat:@"ijarobot-%d",x];
        user.signature  = @"二流程序猿";
        user.userDesc   = @"还是一个坏程序猿";
        
        [userDao insert:user];
    }
    

    
    NSLog(@"insert Success～～～");
//    STFail(@"Unit tests are not implemented yet in iOS-ORMTests");
    
}

@end
