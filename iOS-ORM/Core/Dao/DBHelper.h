//
//  DBHelper.h
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@protocol DataBaseDelegate<NSObject>

@required
- (void) create:(FMDatabase*) db ;
- (void) upgrade:(FMDatabase*) db ;

@end


@interface DBHelper : NSObject

@property (nonatomic,assign) id<DataBaseDelegate> delegate;
@property (nonatomic,retain) NSArray* modelClasses;
@property (nonatomic,retain) FMDatabase* db;

- (DBHelper*) initWithDatabaseName:(NSString*)dbName modelClasses:(NSArray*) _modelClasses;

- (void) create:(FMDatabase*) db;

- (void) upgrade:(FMDatabase*) db;
@end
