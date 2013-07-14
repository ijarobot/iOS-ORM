//
//  User.h
//  iOS-ORM
//
//  注意请给每个model类指定一个int类型的Id属性如下，用来做table的主键
//
//  Created by Android.Qiu on 13-4-23.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "DBHelper.h"

@interface User : NSObject
#warning 注意请给每个model类指定一个int类型的Id属性如下，用来做table的主键
@property int Id;
@property (nonatomic, retain) NSString *lastVisit;
@property (nonatomic, assign) double regDate;
@property (nonatomic, retain) NSString *discussTotal;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, assign) BOOL authed;
@property (nonatomic, assign) BOOL superMod;
@property (nonatomic, assign) BOOL admin;
@property (nonatomic, retain) NSString *signature;
@property (nonatomic, retain) NSString *userLevel;
@property (nonatomic, retain) NSString *postsNum;
@property (nonatomic, retain) NSString *citySlug;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *digNumTotal;
@property (nonatomic, retain) NSString *face;
@property (nonatomic, assign) int credit;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *qq;
@property (nonatomic, retain) NSString *userDesc;
@property (nonatomic, retain) NSString *hitNumTotal;
@property (nonatomic, retain) NSString *cityID;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, assign) long timeLong;

@end
