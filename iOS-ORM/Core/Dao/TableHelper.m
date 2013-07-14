//
//  TableHelper.m
//  iOS-ORM
//
//  根据Class数组,据自动创建,删除表
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "TableHelper.h"
#import <objc/runtime.h>
#import "FMDatabase.h"
#import "RunTimeTool.h"

@implementation TableHelper


//public static <T> void createTablesByClasses(SQLiteDatabase db,
//                                             Class<?>[] clazzs) {
//    for (Class<?> clazz : clazzs)
//        createTable(db, clazz);
//}
//
//public static <T> void dropTablesByClasses(SQLiteDatabase db,
//                                           Class<?>[] clazzs) {
//    for (Class<?> clazz : clazzs)
//        dropTable(db, clazz);
//}


+ (void) createTablesByClasses:(FMDatabase*) db clazzes:(NSArray*) clazzes{
    for(Class clazz in clazzes){
        [TableHelper createTable:db clazz:clazz];
    }
}

+ (void) dropTablesByClasses:(FMDatabase*) db clazzes:(NSArray*) clazzes{
    for(Class clazz in clazzes){
        [TableHelper dropTable:db clazz:clazz];
    }
}


+ (void) createTable:(FMDatabase*) db clazz:(Class) clazz{
    
    NSString* tableName = NSStringFromClass(clazz);

    
    NSMutableDictionary* properties = [RunTimeTool getPropertyNameAndTypeWithClass:clazz];
   
    if([properties count] > 0){
    
        //组装 create table sql
        NSMutableString* sb = [NSMutableString stringWithString:@""];
        [sb appendFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName];

        for(NSString* name in [properties keyEnumerator]){
            
            NSString* columnType = [TableHelper getColumnType:[properties objectForKey:name]];
            
            [sb appendFormat:@"%@  %@",name,columnType];
            //TODO 暂时不处理长度，使用系统默认值
            
            if ([@"Id" isEqualToString:name]) {
                [sb appendString:@" PRIMARY KEY AUTOINCREMENT  NOT NULL "];
            }
            
            [sb appendString:@", "];
            
        }
        [sb deleteCharactersInRange:NSMakeRange([sb length]-2, 1)];//去掉最后一个“,”号
        [sb appendString:@" )"];
        
        // 执行create sql
        if([db open]){
            BOOL result = [db executeUpdate: sb];
            if(result){
                NSLog(@"create table %@ sucess!",tableName);
            }else{
                NSLog(@"create table %@ fail!",tableName);
            }
            [db close];
        }else{
            NSLog(@"when create table %@ fail,Reason: open db fail!",tableName);
        }
        
        
    }else{
        NSLog(@"create table %@ fail, you Class %@ write hava error!",tableName,tableName);
    }
    
    
    
    
    
}

+ (void) dropTable:(FMDatabase*) db clazz:(Class) clazz{
    NSString* tableName = NSStringFromClass(clazz);
    if(![@"" isEqualToString:tableName]){
        if([db open]){
            BOOL result = [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName]];
            if(result){
                 NSLog(@"drop table %@ sucess!",tableName);
            }else{
                 NSLog(@"drop table %@ fail!",tableName);
            }
            [db close];
        }else{
             NSLog(@"when drop table %@ fail,Reason: open db fail!",tableName);
        }

    }

}


+ (NSString*) getColumnType:(NSString*)propertyType{
    
    
    if([propertyType isEqualToString:@"NSString"]){
        return @"TEXT";
    }
    if([propertyType isEqualToString:@"f"]){//float
        return @"FLOAT";
    }
    if([propertyType isEqualToString:@"^i"]){//NSInteger
        return @"INTEGER";
    }
    if([propertyType isEqualToString:@"i"]){//int
        return @"INTEGER";
    }
    if([propertyType isEqualToString:@"I"]){//NSUInteger
        return @"INTEGER";
    }
    if([propertyType isEqualToString:@"d"]){//double
        return @"DOUBLE";
    }
    if([propertyType isEqualToString:@"c"]){//BOOL
        return @"VARCHAR(5)";
    }
    if([propertyType isEqualToString:@"C"]){//Bool
        return @"VARCHAR(5)";
    }
//    if([propertyType isEqualToString:@"enum"]){//enum不处理
//        return @"VARCHAR(10)";
//    }
    if([propertyType isEqualToString:@"NSData"]){//大字段流
        return @"BLOB";
    }
    return @"TEXT";

}





@end

