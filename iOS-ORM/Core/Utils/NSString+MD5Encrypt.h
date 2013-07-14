//
//  NSString+MD5Encrypt.h
//  Test
//
//  Created by Android.Qiu on 13-4-22.
//  Copyright (c) 2013年 ijarobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>  
#include <CommonCrypto/CommonHMAC.h>

@interface NSString(MD5)

+ (NSString *)md5Encrypt:(NSString*)orgStr;

- (NSString *)md5Encrypt;

- (NSString*) HMACWithSecret:(NSString*) secret;


@end
