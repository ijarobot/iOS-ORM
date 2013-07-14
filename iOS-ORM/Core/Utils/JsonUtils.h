//
//  JsonUtils.h
//  Test
//
//  Created by Android.Qiu on 13-4-24.
//  Copyright (c) 2013年 Android.Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

+(id) josnToOjbect:(Class) clazz jsonStr:(NSString *) jsonStr;


+(id) objectWithDictionary:(Class) clazz dic:(NSDictionary *) jsonDic;


@end
