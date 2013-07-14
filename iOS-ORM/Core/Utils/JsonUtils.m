//
//  JsonUtils.m
//  Test
//
//  Created by Android.Qiu on 13-4-24.
//  Copyright (c) 2013年 Android.Qiu. All rights reserved.
//

#import "JsonUtils.h"
#import "JSONKit.h"
#import <objc/runtime.h>

@implementation JsonUtils

+(id) josnToOjbect:(Class) clazz jsonStr:(NSString *) jsonStr{
    return  [JsonUtils objectWithDictionary:clazz dic:[jsonStr objectFromJSONString]];
}



+(id) objectWithDictionary:(Class) clazz dic:(NSDictionary *) jsonDic{
    id obj = [[clazz alloc] init];
    
    for(NSString * key in [jsonDic keyEnumerator]){
        
        id value = [jsonDic objectForKey:key];
        
        if([value isKindOfClass:[NSDictionary class]]){//此时应该是自己定义的 Model
            
            //得到key对应属性的数据类型，比如 T@"Topic",&,N,V_data  变成 Topic
            NSString *propertyType =[NSString  stringWithUTF8String: property_getAttributes(class_getProperty(clazz,[key UTF8String]))];
            propertyType = [propertyType componentsSeparatedByString:@","][0];
            propertyType = [propertyType stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
            propertyType = [propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSLog(@"  type %@ ", propertyType);
            Class keyClass = objc_getClass([propertyType UTF8String]);
            
            id keyValue = [JsonUtils objectWithDictionary:keyClass dic:value];
            
            @try {
                [obj setValue:keyValue forKey:key];
            }
            @catch (NSException *exception) {
                
            }
            
            
        }else if([value isKindOfClass:[NSArray class]]){// 此时应该是数据或者说List
            
            NSMutableArray* list = [NSMutableArray array];
            for(id item in value){
                //                [list addObject:item];
                //TODO 问题来了，无法知道这是一个什么类型的Ａｒｒａｙ
                
            }
            
            
        }else{
            
            //        if([obj respondsToSelector:@selector(key)]){
            //            [obj setValue:[dic objectForKey:key] forKey:key];
            //        }
            //可能没有相应的属性所有try起来，或用上面注释的代码,但上面的方式也许会有性能问题，未测试，有空试试
            @try {
                [obj setValue:[jsonDic objectForKey:key] forKey:key];
            }
            @catch (NSException *exception) {
                
            }
            
        }
        
    }
    
    return [obj autorelease];
}


@end
