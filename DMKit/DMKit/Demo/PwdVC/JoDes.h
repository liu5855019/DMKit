//
//  JoDes.h
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/8/2.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@interface JoDes : NSObject

+ (NSString *) encode:(NSString *)str key:(NSString *)key;
+ (NSString *) decode:(NSString *)str key:(NSString *)key;

@end
