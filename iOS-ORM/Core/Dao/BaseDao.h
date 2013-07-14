//
//  BaseDao.h
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"
#import "FMDatabase.h"


@interface BaseDao : NSObject

@property (nonatomic,retain) DBHelper* dbHelper;
@property (nonatomic,retain) NSString* tableName;
@property (nonatomic,retain) NSString* idColumn;
@property (nonatomic,assign) Class  clazz;



- (BaseDao*) initWithDBHelper:(DBHelper*) _dbHelper clazz:(Class) _clazz;

- (NSArray*) find;

- (NSArray*) find:(NSString*) selection selectionArgs: (NSArray*)selectionArgs;


- (NSArray*) find:(NSString*) selection
    selectionArgs: (NSArray*)selectionArgs
          groupBy:(NSString*) groupBy
           having: (NSString*) having
          orderBy: (NSString*) orderBy
            limit: (NSString*) limit;



- (NSArray*) findBySql:(NSString*) sql selectionArgs: (NSArray*)selectionArgs;



- (NSArray*) getList: (NSMutableArray*) list fromReust:(FMResultSet*) result;

- (id) get:(int)Id;

- (id) getId:(NSString*)Id;

- (BOOL) insert:(id)entity;

- (BOOL) delete:(int)Id;

- (BOOL) deleteByID:(NSString*)Id;

- (BOOL) deleteAll:(NSString*)Id;

- (BOOL) update:(id)entity;

@end
