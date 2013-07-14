//
//  HttpRequestUtils.h
//  Test
//
//  Created by Android.Qiu on 13-4-19.
//  Copyright (c) 2013年 Android.Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "ASIDownloadCache.h"

@interface HttpRequestUtils : NSObject{
    id                          deserializeTo;
}

@property (retain, nonatomic)  NSURL*                      url;
@property (retain, nonatomic)  NSMutableDictionary*        params;
@property (retain, nonatomic)  id                          handler;
@property (retain, nonatomic)  id                          deserializeTo;

@property   SEL       action;
@property   BOOL      logging;



+ (HttpRequestUtils*) getHttpRequestUtils;

//+ (HttpRequestUtils*) create: (id) handler action: (SEL) action url:(NSString*)url : (NSMutableDictionary*) pramas;

+ (HttpRequestUtils*) create: (id) handler action: (SEL) action url:(NSString*)url pramas: (NSMutableDictionary*) pramas deserializeTo: (id) deserializeTo;

+ (HttpRequestUtils*) create: (id) handler action: (SEL) action url:(NSString*)url pramas: (NSMutableDictionary*) pramas deserializeTo: (id) deserializeTo debug:(BOOL)debug;




#pragma mark 异步post
-(void)post;


#pragma mark 异步get
-(void)get;
-(void)get:(NSString*) url param:(NSMutableDictionary *)param;

#pragma mark 同步post
-(void)sycnPost;


#pragma mark 同步get
-(void)sycnGet;


@end
