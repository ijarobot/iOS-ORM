//
//  HttpRequestUtils.m
//  Test
//
//  Created by Android.Qiu on 13-4-19.
//  Copyright (c) 2013年 Android.Qiu. All rights reserved.
//

#import "HttpRequestUtils.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Reachability.h"
#import "BaseResult.h"
#import "ApiError.h"

@implementation HttpRequestUtils

static HttpRequestUtils *instance=nil;

@synthesize     handler;
@synthesize     action;
@synthesize     url;
@synthesize     params;
@synthesize     deserializeTo;
@synthesize     logging;




- (id) init {
    if(self = [super init]){

    }
    return self;
}

- (void) dealloc{
    
    handler = nil;
    action  = nil;
    url     = nil;
    params  = nil;
    deserializeTo = nil;
//    logging       = nil;

    [super dealloc];
}


+(HttpRequestUtils*) getHttpRequestUtils{
    @synchronized(self) {
        if(instance == nil){
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}



//+ (HttpRequestUtils*) create: (id) handler action: (SEL) action url:(NSString*)url : (NSMutableDictionary*) pramas{
//    return [self create:<#(id)#> action:<#(SEL)#> url:<#(NSString *)#> :<#(NSMutableDictionary *)#> deserializeTo:<#(id)#>]
//}

+ (HttpRequestUtils*) create: (id) handler action: (SEL) action url:(NSString*)url pramas: (NSMutableDictionary*) pramas deserializeTo: (id) deserializeTo{
    HttpRequestUtils *httpRequest = [[HttpRequestUtils alloc] init];
    
    httpRequest.handler = handler;
    httpRequest.action  = action;
    httpRequest.url = [NSURL URLWithString: url];
    httpRequest.params = pramas;
    httpRequest.deserializeTo = deserializeTo;
    httpRequest.logging = YES;
    
    return httpRequest;
}

+ (HttpRequestUtils*) create: (id) handler action: (SEL) action url:(NSString*)url pramas: (NSMutableDictionary*) pramas deserializeTo: (id) deserializeTo debug:(BOOL)debug{
    
    HttpRequestUtils *httpRequest = [HttpRequestUtils create:handler action:action url:url pramas:pramas deserializeTo:deserializeTo];
    httpRequest.logging = debug;

    return httpRequest;
}

#pragma mark 组装URL，将URL进行UTF-8编码
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]])) {
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        [escaped_value release];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

#pragma mark 检查网络，如果网络不可用则处理此错误
- (void) checkNetWork{
    if(![Reachability connectedToNetwork]){
        NSError* error = [NSError errorWithDomain:@"NetworkError" code:400 userInfo:[NSDictionary dictionaryWithObject:@"网络不可用!" forKey:NSLocalizedDescriptionKey]];
		[self handleError: error];
        return;
    }
}

#pragma mark 错误处理
-(void)handleError:(NSError*)error{
	if([self.handler respondsToSelector: self.action]) {
		[self.handler performSelector: self.action withObject: error];
	} 
	if(self.logging) {
		NSLog(@"Error: %@", error.localizedDescription);
	}
}

#pragma mark 服务器API错误处理
-(void)handleApiError:(ApiError*)apiError{

    int code        = [apiError.errorCode intValue];
    NSString* msg   = apiError.msg;
    //TODO, 客户端应该自己自定一个错误信息池，先根据code到池中找错误信息，如果没找到再使用服务端的msg

    
    NSError* error = [NSError errorWithDomain:@"ApiError" code:code userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]];
	if([self.handler respondsToSelector: self.action]) {
		[self.handler performSelector: self.action withObject: error];
	}
	if(self.logging) {
		NSLog(@"Error: %@", error.localizedDescription);
	}
}


#pragma mark 异步post
-(void)post{
    
//    if(![Reachability connectedToNetwork]){
//        
//        //TODO 以下错误码暂时写400
//        
//        NSError* error = [NSError errorWithDomain:@"NetworkError" code:400 userInfo:[NSDictionary dictionaryWithObject:@"网络不可用!" forKey:NSLocalizedDescriptionKey]];
//		[self handleError: error];
//        return;
//    }
    

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];


    
    request.delegate = self;
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:40];
    [request setShouldAttemptPersistentConnection:NO];
    [request setUserAgentString:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31"];
    [request addRequestHeader:@"Accept" value:@"application/json"];

    
    for (NSString* key in [params keyEnumerator]) {
        id val = [params objectForKey:key];
        if ([val isKindOfClass:[NSData class]]) {//TODO other file
            [request addData:val forKey:key];
            
        }
        else if ([val isKindOfClass:[UIImage class]]) {//图片
            NSData* imageData = UIImagePNGRepresentation((UIImage*)val);
            [request addData:imageData withFileName:@"image_from_iOS_BBS.png" andContentType:@"image/png" forKey:key];
        }
        else {//普通字段
            [request addPostValue:val forKey:key];
        }
    }
    
    
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIAskServerIfModifiedCachePolicy];
    [request setSecondsToCache:60*60 * 3];
    
    [request startAsynchronous];
    
}


#pragma mark 异步get
-(void)get:(NSString*) url param:(NSMutableDictionary *)param{
    
    NSString* urlString = [[self class] serializeURL:url params:param];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
//    [request clearDelegatesAndCancel];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:NO];
    
    [request startAsynchronous];
}


#pragma mark 同步post
+(NSString*)sycnPost:(NSString*) url param:(NSMutableDictionary *)param{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setDelegate:self];
    [request setValidatesSecureCertificate:NO];
//    [request addRequestHeader:<#(NSString *)#> value:<#(NSString *)#>];
    [request setUserAgentString:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    
    for (NSString* key in [param keyEnumerator]) {
        id val = [param objectForKey:key];
        if ([val isKindOfClass:[NSData class]]) {//TODO other file
            [request addData:val forKey:key];
            
        }
        else if ([val isKindOfClass:[UIImage class]]) {//图片
            NSData* imageData = UIImagePNGRepresentation((UIImage*)val);
            [request addData:imageData withFileName:@"image_from_iOS_BBS.png" andContentType:@"image/png" forKey:key];
        }
        else {//普通字段
            [request addPostValue:val forKey:key];
        }
    }
    
    [request startSynchronous];
    NSString *responseData = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"responseData : %@", responseData);
    return  responseData;
}


#pragma mark 同步get
-(void)sycnGet:(NSString*) url param:(NSMutableDictionary *)param{
    
}


#pragma mark ASIHTTPRqeust 的两个回调
/**
    成功时的回调，
    1.将json转了BaseResult 检测API是否调成功，失败handleApiError
    2.成功，则将json转成相应的XXXResult，交给handler的action去处理
 */
- (void)requestFinished:(ASIHTTPRequest *)request
{

    
    //判断返回的数据是否来自本地缓存
    if (request.didUseCachedResponse) {
        NSLog(@"使用缓存数据");
    } else {
        NSLog(@"请求网络数据");
    }
    
    NSString *responseStr = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];

    if(logging){
        NSLog(@"服务器返回JSON：\n%@",responseStr);
    }
//    if([request responseStatusCode] != 200){
//        responseStr = [responseStr componentsSeparatedByString:@"X-Powered-By: PHP/5.3.16\r\n\r\n"][1];//服务器返回数据好像有点总是故加上此处理
//    }//此处理不是万能的，返回的数据好像不是100%这个规则
    if ([responseStr hasPrefix:@"HTTP/1.1 121001\r\n"]) {
        responseStr = [responseStr stringByReplacingCharactersInRange:NSMakeRange(0,169) withString:@""];
    }

    
    if ([responseStr hasPrefix:@"HTTP/1.1 121014\r\n"]) {
        responseStr = [responseStr stringByReplacingCharactersInRange:NSMakeRange(0,169-26) withString:@""];
    }
    
    NSArray* responseArray = [responseStr componentsSeparatedByString:@"PHP/5.3.14\r\n\r\n"];
    if([responseStr hasPrefix:@"HTTP/1.1 "] &&responseArray != NULL  && responseArray.count == 2){
        responseStr = responseArray[1];
    }
    
    if([self.handler respondsToSelector:self.action]){
        
        NSDictionary* jsonDic = [responseStr objectFromJSONString];
        
        BaseResult* baseResult = [BaseResult modelObjectWithDictionary:jsonDic];
        if(!baseResult.success){
            ApiError* apiError = [ApiError fillWithErrorCode:baseResult.errorCode msg:baseResult.msg];
            [self handleApiError: apiError];
        }else{
        
            if([deserializeTo respondsToSelector: @selector(initWithDictionary:)]) {
                deserializeTo =  [deserializeTo  initWithDictionary:jsonDic];
                [self.handler performSelector:self.action withObject:self.deserializeTo];
                
            }else{
                
                if(logging){
                    
                    NSString* msg = @"同学你的代码错了，\n 某个model类少了 initWithDictionary 方法！！！";
                    
                    [self.handler performSelector:self.action withObject:msg];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DEBUG MSG" message:msg delegate:nil cancelButtonTitle:@"我现在去改代码" otherButtonTitles:nil];
                    
                    [alert show];
                    [alert release];
                }
            }

        }
        
    }else{
        
        if(logging){
            
            NSString* msg = @"同学你的代码错了，\n 某个xxxContraller类少了 xxxxHandler 方法！！！";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DEBUG MSG" message:msg delegate:nil cancelButtonTitle:@"我现在去改代码" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
        }
        
        
    }
    

}

/**
    网络请求失败时的回调
 
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
    if(logging){
        NSLog(@"网络请求失败\n    原因:%@ \n  详情:%@"
              , [error localizedFailureReason], [error localizedDescription]);
        
    }
    
    //TODO 是否需要对 timeOut 这种错误进行特别的处理
    
    [self handleError:error];
    
}



@end
