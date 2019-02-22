//
//  NSData+DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/27.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "NSData+DMTools.h"
#import <CommonCrypto/CommonCrypto.h> //加密相关

@implementation NSData (DMTools)


#pragma mark - Hash

//hash  参考YYKit

/** Returns a lowercase NSString for md2 hash */
- (NSString *)md2String
{
    unsigned char result[CC_MD2_DIGEST_LENGTH];  // CC_MD2_DIGEST_LENGTH == 16
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}


/** Returns an NSData for md2 hash*/
- (NSData *)md2Data
{
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD2_DIGEST_LENGTH];
}

/** Returns a lowercase NSString for md4 hash*/
- (NSString *)md4String
{
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/** Returns an NSData for md4 hash */
- (NSData *)md4Data
{
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD4_DIGEST_LENGTH];
}

/** Returns a lowercase NSString for md5 hash */
- (NSString *)md5String
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/** Returns an NSData for md5 hash */
- (NSData *)md5Data
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

/** Returns a lowercase NSString for sha1 hash */
- (NSString *)sha1String
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/** Returns an NSData for sha1 hash */
- (NSData *)sha1Data
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

/** Returns a lowercase NSString for sha224 hash */
- (NSString *)sha224String
{
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/** Returns an NSData for sha224 hash */
- (NSData *)sha224Data
{
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
}

/** Returns a lowercase NSString for sha256 hash */
- (NSString *)sha256String
{
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/** Returns an NSData for sha256 hash */
- (NSData *)sha256Data
{
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

/** Returns a lowercase NSString for sha384 hash */
- (NSString *)sha384String
{
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/** Returns an NSData for sha384 hash */
- (NSData *)sha384Data
{
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
}

/** Returns a lowercase NSString for sha512 hash */
- (NSString *)sha512String
{
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/** Returns an NSData for sha512 hash */
- (NSData *)sha512Data
{
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - hmac

- (NSString *)hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key {
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(alg, cKey, strlen(cKey), self.bytes, self.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSData *)hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(NSData *)key {
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    CCHmac(alg, [key bytes], key.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}




/** Returns a lowercase NSString for hmac using algorithm md5 with key */
- (NSString *)hmacMD5StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgMD5 withKey:key];
}

/** Returns an NSData for hmac using algorithm md5 with key */
- (NSData *)hmacMD5DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgMD5 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA1DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA224StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA224DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA256DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA384StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA384DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA512DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA512 withKey:key];
}


#pragma mark - Aes
/** 使用的是aes ,自动根据key长度计算aesKeySize128,aesKeySize192,aesKeySize256 **iv长度推荐16字节** CBC加密模式, 数据块128位 */
+ (NSData *)aesWithData:(NSData *)contentData key:(NSData *)keyData iv:(NSData *)ivData operation:(CCOperation)operation
{
    NSUInteger dataLength = contentData.length;
    
    if (ivData.length != 16) {
        NSLog(@"推荐iv长度为16字节");
    }
    
    void const *ivBytes = ivData.bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    //当 keyData.length == 17  keyLength == 16(kCCKeySizeAES128) 的时候,按照keyData的前16位来计算结果
    //当 keyData.length == 15  keyLength == 24 || 32 的时候,也会计算有误
    size_t keyLength;
    if (keyData.length <= kCCKeySizeAES128) {
        keyLength = kCCKeySizeAES128;
    } else if (keyData.length <= kCCKeySizeAES192) {
        keyLength = kCCKeySizeAES192;
    } else {
        keyLength = kCCKeySizeAES256;
    }
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          keyLength,
                                          ivBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize freeWhenDone:YES];
    }
    free(operationBytes);
    return nil;
}

- (NSData *)aesEncryptWithKey:(NSData *)key IV:(NSData *)iv
{
    return [NSData aesWithData:self key:key iv:iv operation:kCCEncrypt];
}

- (NSData *)aesDecryptWithKey:(NSData *)key IV:(NSData *)iv
{
    return [NSData aesWithData:self key:key iv:iv operation:kCCDecrypt];
}

#pragma mark - Des
/** Des 加密解密 , 0<=key<=8,超过8位实际使用只有前8位 , 当iv长度 < 8的时候使用ecb(ecb不需要iv),其它使用cbc(就算长度大于了8位,实际使用只有前8位), */
+ (NSData *)desWithData:(NSData *)contentData key:(NSData *)keyData iv:(NSData *)ivData operation:(CCOperation)operation
{
    NSUInteger dataLength = contentData.length;
    
    void const *ivBytes = ivData.bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    //生成输出需要的参数
    size_t operationSize = dataLength + kCCBlockSizeDES;
    void *operationBytes = malloc(operationSize);
    size_t actualOutSize = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmDES,
                                          ivData.length >=8 ? kCCOptionPKCS7Padding : kCCOptionPKCS7Padding|kCCOptionECBMode ,
                                          keyBytes,
                                          kCCKeySizeDES,
                                          ivData.length >=8 ? ivBytes : NULL,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize freeWhenDone:YES];
    }
    free(operationBytes);
    return nil;
}

- (NSData *)desEncryptWithKey:(NSData *)key IV:(NSData *)iv
{
    return [NSData desWithData:self key:key iv:iv operation:kCCEncrypt];
}

- (NSData *)desDecryptWithKey:(NSData *)key IV:(NSData *)iv
{
    return [NSData desWithData:self key:key iv:iv operation:kCCDecrypt];
}



@end
