//
//  NSString+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2017/12/29.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "NSString+DMTools.h"
#import <CommonCrypto/CommonDigest.h>   //md5 用到

@implementation NSString (DMTools)


- (BOOL)isNullString
{
    if (self.isNullObject) {
        return YES;
    }
    if (![self isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (self.length == 0 || [self isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isAllWithSpace
{
    if ([self isNullString]) {
        return YES;
    }
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str.length == 0;
}



- (BOOL)isHaveSpace
{
    if ([self isAllWithSpace]) {
        return YES;
    }
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str.length != self.length;
}




- (BOOL)isEmail
{   //@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *emailRegex = @"^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isInArray:(NSArray *)array
{
    for (NSString *string in array) {
        if ([self isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}


- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)MD5
{
    const char* aString = [self UTF8String];
    unsigned char result[16];
    CC_MD5(aString, (CC_LONG)strlen(aString), result);
    NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
    return [hash lowercaseString];
}





#pragma mark - aes


- (NSString *)aesEncryptWithKey:(NSString *)key IV:(NSString *)iv
{
    NSData *contentData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *result = [contentData aesEncryptWithKey:keyData IV:ivData];
    
    return [result base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *)aesDecryptWithKey:(NSString *)key IV:(NSString *)iv
{
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *result = [contentData aesDecryptWithKey:keyData IV:ivData];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}


- (void)dealloc
{
    NSLog(@"%@ -- over",self);
}

@end
