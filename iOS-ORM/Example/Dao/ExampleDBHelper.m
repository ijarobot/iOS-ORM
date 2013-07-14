//
//  BBSDBHelper.m
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "ExampleDBHelper.h"
#import "User.h"

static NSString* dbName = @"examole_app_db.sqlite";//DB file name

@implementation ExampleDBHelper


- (ExampleDBHelper*) init{
    NSArray*  modelClasses = @[[User class]];//TODO: 添加其他的model类到此处
    
    if ([super init]) {
        [super initWithDatabaseName:dbName modelClasses:modelClasses];
    }

    return self;
}


#pragma mark DataBaseDelegate
- (void) upgrade:(FMDatabase*) db {
    //TODO
}

@end
