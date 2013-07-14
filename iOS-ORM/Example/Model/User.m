//
//  User.m
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-23.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "User.h"

@implementation User


@synthesize Id = _id;
@synthesize lastVisit = _lastVisit;
@synthesize regDate = _regDate;
@synthesize discussTotal = _discussTotal;
@synthesize userID = _userID;
@synthesize sex = _sex;
@synthesize authed = _authed;
@synthesize superMod = _superMod;
@synthesize admin = _admin;
@synthesize signature = _signature;
@synthesize userLevel = _userLevel;
@synthesize postsNum = _postsNum;
@synthesize citySlug = _citySlug;
@synthesize email = _email;
@synthesize mobile = _mobile;
@synthesize digNumTotal = _digNumTotal;
@synthesize face = _face;
@synthesize credit = _credit;
@synthesize userName = _userName;
@synthesize qq = _qq;
@synthesize userDesc = _userDesc;
@synthesize hitNumTotal = _hitNumTotal;
@synthesize cityID = _cityID;
@synthesize cityName = _cityName;
@synthesize timeLong = _timeLong;







-(void) dealloc{

    [_lastVisit release];
    [_discussTotal release];
    [_userID release];
    [_sex release];
    [_signature release];
    [_userLevel release];
    [_postsNum release];
    [_citySlug release];
    [_email release];
    [_mobile release];
    [_digNumTotal release];
    [_face release];
    [_userName release];
    [_qq release];
    [_userDesc release];
    [_hitNumTotal release];
    [_cityID release];
    [_cityName release];

    [super dealloc];
}




@end
