//
//  BaseDao.m
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "BaseDao.h"
#import "DBHelper.h"
#import "RunTimeTool.h"

@implementation BaseDao

@synthesize dbHelper;
@synthesize tableName;
@synthesize idColumn;
@synthesize clazz;


- (BaseDao*) initWithDBHelper:(DBHelper*) _dbHelper clazz:(Class) _clazz{
    
    if([super init]){
        self.dbHelper   = _dbHelper;
        self.clazz      = _clazz;
        self.tableName  = NSStringFromClass(_clazz);
        self.idColumn   = @"Id";
    }
    return self;
}


- (NSArray*) find{
    return [self findBySql:[NSString stringWithFormat:@"SELECT * FROM %@ ",self.tableName] selectionArgs:NULL];
}

- (NSArray*) find:(NSString*) selection selectionArgs: (NSArray*)selectionArgs{
    
    return [self find:selection selectionArgs:selectionArgs groupBy:NULL having:NULL orderBy:NULL limit:NULL];
}


- (NSArray*) find:(NSString*) selection
                   selectionArgs: (NSArray*)selectionArgs
                         groupBy:(NSString*) groupBy
                          having: (NSString*) having
                         orderBy: (NSString*) orderBy
                           limit: (NSString*) limit{
                               
    NSMutableArray* list = [NSMutableArray array];
    FMDatabase* db = nil;
    @try {
        db = self.dbHelper.db;
        NSMutableString* sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ",self.tableName,selection];
        if(groupBy){
            [sql appendFormat:@"GROUP BY %@",groupBy];
            if(having){
                [sql appendFormat:@"HAVING %@",having];
            }
        }
        if(orderBy){
            [sql appendFormat:@"ORDER BY %@",orderBy];
        }
        if(limit){
            [sql appendFormat:@"LIMIT %@",limit];
        }
        
        if ([db open]) {
           FMResultSet* result = [db executeQuery:sql withArgumentsInArray:selectionArgs];
           [self getList:list fromReust:result];
        }else{
            NSLog(@"when execute query sql db can't open!!!");
        }
    }
    @catch (NSException *exception) {
        NSLog(@" %@ ",exception);
    }
    @finally {
        if(db){
            [db close];
        }
    }
    return list;
}



- (NSArray*) findBySql:(NSString*) sql selectionArgs: (NSArray*)selectionArgs{
    
    NSMutableArray* list = [NSMutableArray array];
    FMDatabase* db = nil;
    @try {
        db = self.dbHelper.db;
        if ([db open]) {
            FMResultSet* result = [db executeQuery:sql withArgumentsInArray:selectionArgs];
            [self getList:list fromReust:result];
        }else{
            NSLog(@"when execute query sql db can't open!!!");
        }
    }
    @catch (NSException *exception) {
        NSLog(@" %@ ",exception);
    }
    @finally {
        if(db){
            [db close];
        }
    }
    return list;
}



- (NSArray*) getList: (NSMutableArray*) list fromReust:(FMResultSet*) result{
    
    NSMutableDictionary* propertyDic = [RunTimeTool getPropertyNameAndTypeWithClass:self.clazz];
    
    while ([result next]) {
        id entity = [[self.clazz alloc] init];//TOOD relese
        for (NSString* key in [propertyDic keyEnumerator]) {

            id value = [result objectForColumnName:key];
            
            NSString* type = [propertyDic objectForKey:key];
            if([@"C" isEqualToString:type] || [@"c" isEqualToString:type]){//Boolean
               
                if([value isEqualToString:@"0"] || [value isEqualToString:@"1"]){
                    [entity setValue:[NSNumber numberWithInt: [value intValue]] forKey:key];
                }

            }else{
                [entity setValue:value forKey:key];
            }
//            NSLog(@"name %@  value %@",key, value);
            
            
        }
        [list addObject:entity];
    }
    return list;
}

- (id) get:(int)Id{
    
    return [self getId:[NSString stringWithFormat:@"%i",Id]];
}

-(id) getId:(NSString*)Id{

    NSString* selection = @"Id = ?";
    NSArray*  selectionArgs = @[Id];
    
    NSArray* list = [self find:selection
                     selectionArgs:selectionArgs
                           groupBy:NULL
                            having:NULL
                           orderBy:NULL
                             limit:NULL];
    
    if(list && list.count > 0){
        return list[0];
    }else{
        return NULL;
    }
}

-(BOOL) insert:(id)entity{
    FMDatabase* db = nil;
    @try {
        db = self.dbHelper.db;
        
        NSMutableString* insertPx = [NSMutableString stringWithFormat:@"insert into %@ (",self.tableName];
        NSMutableString* valuesHx = [NSMutableString stringWithFormat:@"values ("];
        NSMutableArray*  values   = [NSMutableArray array];
        
        
        NSMutableDictionary* nameAndValueDic = [RunTimeTool getPropertiesNameAndValueWithClassIncludeNil:entity];
        for (NSString* name in [nameAndValueDic keyEnumerator]) {
            if(![@"Id" isEqualToString:name]){//不是主键
                [insertPx appendFormat:@"%@, ",name];
                [valuesHx appendFormat:@"?, "];
                id value = [entity valueForKey:name];
                [values addObject:value == nil ? [NSNull null] : value];
            }

        }
        
        NSString* sql = [NSString stringWithFormat:@"%@%@%@%@",
                         [insertPx substringToIndex:[insertPx length]-2],@" ) ",
                         [valuesHx substringToIndex:[valuesHx length]-2],@" ) "];
        
        if ([db open]) {
            return [db executeUpdate:sql withArgumentsInArray:values];
        }else{
             NSLog(@"insert fail Reason: %@ ",@"open db fail!!");
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insert fail Reason: %@ ",exception);
        return NO;
    }
    @finally {
        if(db){
            [db close];
        }
    }
}


- (BOOL) delete:(int)Id{
    return [self deleteByID:[NSString stringWithFormat:@"%i",Id]];
}


- (BOOL) deleteAll:(NSString*)Id{
    FMDatabase* db = nil;
    @try {
        db = self.dbHelper.db;
        NSString* sql = [NSString stringWithFormat:@"delete from %@ ",self.tableName];
        
        if([db open]){
            return [db executeUpdate:sql];
        }else{
            NSLog(@"delete all fail Reason: %@ ",@"open db fail!!");
            return NO;
        }
    }
    @catch (NSException *ex) {
        NSLog(@"delete all fail Reason: %@ ",ex);
        return NO;
    }
    @finally {
        if (db) {
            [db close];
        }
    }
}

- (BOOL) deleteByID:(NSString*)Id{
    FMDatabase* db = nil;
    @try {
        db = self.dbHelper.db;
        NSString* sql = [NSString stringWithFormat:@"delete from %@ where Id = ?",self.tableName];
        
        if([db open]){
           return [db executeUpdate:sql,Id];
        }else{
            NSLog(@"delete fail Reason: %@ ",@"open db fail!!");
            return NO;
        }
    }
    @catch (NSException *ex) {
            NSLog(@"delete fail Reason: %@ ",ex);
            return NO;        
    }
    @finally {
        if (db) {
            [db close];
        }
    }
}


-(BOOL) update:(id)entity{
    FMDatabase* db = nil;
    @try {
        db = self.dbHelper.db;
        
        NSMutableString* updatePx = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",self.tableName];

        NSMutableDictionary* nameAndValueDic = [RunTimeTool getPropertiesNameAndValueWithClassIncludeNil:entity];
        for (NSString* name in [nameAndValueDic keyEnumerator]) {
            if(![@"Id" isEqualToString:name]){//不是主键
                [updatePx appendFormat:@"%@ = :%@, ",name,name];
            }
        }
        
        NSString* sql = [NSString stringWithFormat:@"%@ where Id = :Id",[updatePx substringToIndex:[updatePx length]-2]];
        
        
        if ([db open]) {
            return [db executeUpdate:sql withParameterDictionary:nameAndValueDic];
        }else{
            NSLog(@"update fail Reason: %@ ",@"open db fail!!");
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"update fail Reason: %@ ",exception);
        return NO;
    }
    @finally {
        if(db){
            [db close];
        }
    }
}






- (void) dealloc{
    dbHelper = nil;
    clazz = nil;
    tableName = nil;
    idColumn = nil;
    
    [super dealloc];
}

@end
