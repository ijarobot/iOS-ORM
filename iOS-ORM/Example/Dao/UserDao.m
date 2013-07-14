//
//  UserDao.m
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-23.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "UserDao.h"
#import "ExampleDBHelper.h"
#import "User.h"

@implementation UserDao

-(UserDao*) init{
    
    if([super init]){
        [super initWithDBHelper:[[ExampleDBHelper alloc] init] clazz:[User class]];
    }
    return self;
}


@end
