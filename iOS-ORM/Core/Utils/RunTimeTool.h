//
//  RunTimeTool.h
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunTimeTool : NSObject

+ (NSMutableDictionary* ) getPropertiesNameAndValueWithClassIncludeNil:(id) instance;

+ (NSMutableDictionary* ) getPropertiesNameAndValueWithClassNotIncludeNil:(id) instance;

+ (NSMutableDictionary* ) getPropertiesNameAndValueWithClass:(id) instance includeNil:(BOOL)includeNil;

+ (NSMutableDictionary*) getPropertyNameAndTypeWithClass:(Class) clazz;

@end
