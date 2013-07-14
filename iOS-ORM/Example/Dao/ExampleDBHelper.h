//
//  BBSDBHelper.h
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "DBHelper.h"




@interface ExampleDBHelper : DBHelper<DataBaseDelegate>

@property (nonatomic,retain) DBHelper* dbHelper;

- (ExampleDBHelper*) init;

@end
