//
//  RunTimeTool.m
//  iOS-ORM
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "RunTimeTool.h"
#import <objc/runtime.h>

@implementation RunTimeTool


+ (NSMutableDictionary* ) getPropertiesNameAndValueWithClassIncludeNil:(id) instance{
    
    return [RunTimeTool getPropertiesNameAndValueWithClass:instance includeNil:YES];
    
}

+ (NSMutableDictionary* ) getPropertiesNameAndValueWithClassNotIncludeNil:(id) instance{
    
    return [RunTimeTool getPropertiesNameAndValueWithClass:instance includeNil:NO];

}

+ (NSMutableDictionary* ) getPropertiesNameAndValueWithClass:(id) instance includeNil:(BOOL)includeNil{
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([instance class], &propertyCount);
    
    NSMutableDictionary* propertiesNameAndValue = [NSMutableDictionary dictionaryWithCapacity:propertyCount];
    
    for(int x = 0; x < propertyCount; x++){
        
        objc_property_t property = properties[x];
        
        NSString* name = [NSString stringWithUTF8String:property_getName(property)];
        id value = [instance valueForKey:name];
        if(includeNil){
            if(!value){
                value = [NSNull null];
            }
            
            [propertiesNameAndValue setObject:value forKey:name];
            
        }else{
            if(value){
                [propertiesNameAndValue setObject:value forKey:name];
            }
        }
        
    }
    return propertiesNameAndValue;
    
}

#pragma mark 根据Class得到所有属性名&属性的类型 ，返回数据中key 为属性名，value 为类型
+ (NSMutableDictionary*) getPropertyNameAndTypeWithClass:(Class) clazz{

    unsigned int count;
    objc_property_t* properties = class_copyPropertyList(clazz, &count);

    NSMutableDictionary* propertiesNameAndType = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int x = 0; x < count; x++) {

        objc_property_t property = properties[x];

        NSString* name = [NSString stringWithUTF8String:property_getName(property)];
        
        NSString *propertyType =[NSString  stringWithUTF8String: property_getAttributes(class_getProperty(clazz,[name UTF8String]))];
        NSLog(@"  type %@ ", propertyType);
        propertyType = [propertyType componentsSeparatedByString:@","][0];
        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"T" withString:@""];
        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        [propertiesNameAndType setObject:propertyType forKey:name];
        
    }
    
    return propertiesNameAndType;
}



@end
