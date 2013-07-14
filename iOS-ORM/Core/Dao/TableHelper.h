//
//  TableHelper.h
//  iOS-ORM
//
//  根据Class数组,据自动创建,删除表
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface TableHelper : NSObject

+ (void) createTablesByClasses:(FMDatabase*) db clazzes:(NSArray*) clazzes;

+ (void) dropTablesByClasses:(FMDatabase*) db clazzes:(NSArray*) clazzes;

+ (void) createTable:(FMDatabase*) db clazz:(Class) clazz;

+ (void) dropTable:(FMDatabase*) db clazz:(Class) clazz;
    
+ (NSString*) getColumnType:(NSString*)propertyType;

@end
