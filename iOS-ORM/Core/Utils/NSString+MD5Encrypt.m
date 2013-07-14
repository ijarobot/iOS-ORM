//
//  NSString+MD5Encrypt.m
//  Test
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import "NSString+MD5Encrypt.h"
#include <CommonCrypto/CommonHMAC.h>


@implementation NSString (MD5)

#pragma mark md5加密
+ (NSString *)md5Encrypt:(NSString*)orgStr{
    const char *original_str = [orgStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)md5Encrypt {
    return [NSString md5Encrypt:self];
}

#pragma mark md5加密
#pragma mark  hmac加密 给api签名使用
- (NSString*) HMACWithSecret:(NSString*) secret{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [self UTF8String];
    unsigned char    mac[CC_MD5_DIGEST_LENGTH];
    char             hexmac[2 * CC_MD5_DIGEST_LENGTH + 1];
    char             *p;
    
    CCHmacInit(&ctx, kCCHmacAlgMD5, key, strlen( key ));
    CCHmacUpdate(&ctx, str, strlen(str) );
    CCHmacFinal(&ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[i] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}

@end
