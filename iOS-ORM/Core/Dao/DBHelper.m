//
//  DBHelper.m
//  iOS-ORM
//
//  最好根据项目的情况，写一个子类 实现<DataBaseDelegate>， 且重写initWithDatabaseName & upgrade方法
//  特别是upgrade方法默认是直接删除所有已经存的表
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabase.h"
#import "TableHelper.h"

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DB_PATH             [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"mf_xxx_app_db.sqlite"];/* DB名随意改动 */

@implementation DBHelper

@synthesize delegate;
@synthesize modelClasses;
@synthesize db;


- (DBHelper*) initWithDatabaseName:(NSString*)dbName modelClasses:(NSArray*) _modelClasses{

    if([super init]){
        self.modelClasses = _modelClasses;
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString *dbpath =  [PATH_OF_DOCUMENT stringByAppendingPathComponent:dbName];

        if ([fileManager fileExistsAtPath:dbpath] == NO) {//TODO 有没有比这更好的条件判断？
            // create db table
            self.db = [FMDatabase databaseWithPath:dbpath];
            if(delegate){
                [self.delegate create:db];
            }else{
                [self create:db];
            }

        }else{
            //update db table
            self.db = [FMDatabase databaseWithPath:dbpath];
            if(delegate){
                [self.delegate upgrade:db];
            }else{
                [self upgrade:db];
            }
            

        }
    }
    return self;
}

- (void) create:(FMDatabase*) _db  {
    [TableHelper createTablesByClasses:db clazzes:self.modelClasses];
}


- (void) upgrade:(FMDatabase*) _db {
    [TableHelper dropTablesByClasses:db clazzes:self.modelClasses];
}


- (void) dealloc{
    modelClasses = nil;
    if(db){
        [db close];
        db = nil;
    }
    [super dealloc];
}

@end
