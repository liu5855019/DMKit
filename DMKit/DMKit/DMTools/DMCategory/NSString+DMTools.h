//
//  NSString+DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/29.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DMTools)




- (BOOL)isNullString;
- (BOOL)isAllWithSpace;
- (BOOL)isHaveSpace;


- (BOOL)isEmail;
- (BOOL)isInArray:(NSArray *)array;


- (NSString *)pinyin;
- (NSString *)MD5;



#pragma mark - aes
/** 使用的是aes , 自动根据key长度计算aes128,aes192,aes256 , **iv长度推荐16位** , CBC加密模式 , 数据块128位 , 加密结果使用base64输出 */
- (NSString *)aesEncryptWithKey:(NSString *)key IV:(NSString *)iv;
/** 使用的是aes , 先解base64后解密 , 自动根据key长度计算aes128,aes192,aes256 , **iv长度推荐16位** , CBC加密模式 , 数据块128位 */
- (NSString *)aesDecryptWithKey:(NSString *)key IV:(NSString *)iv;


@end
