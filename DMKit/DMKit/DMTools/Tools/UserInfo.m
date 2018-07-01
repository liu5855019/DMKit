//
//  Userid.m
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/6/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "UserInfo.h"

#define kUserInfo @"Userinfo"
static NSString * const kTourist = @"tourist";              ///<游客token

@interface UserInfo ()

@property (nonatomic , assign) CGFloat scaleH;
@property (nonatomic , assign) CGFloat scaleW;

@end


@implementation UserInfo

+(instancetype) shareUser{
    static UserInfo *userInfo;
    if (userInfo) {
        return userInfo;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [DMTools filePathInDocuntsWithFile:kUserInfo];
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if (!userInfo) {
            userInfo = [[self alloc] init];
        }
    });
    
    return userInfo;
}

+(NSString *)token
{
    return [UserInfo shareUser].token.length ? [UserInfo shareUser].token : kTourist;
}


-(void)saveDatas{
    NSString *filePath = [DMTools filePathInDocuntsWithFile:kUserInfo];
    
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

-(void)removeDatas{
    //删除归档的文件
    NSString *filePath = [DMTools filePathInDocuntsWithFile:kUserInfo];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

-(void)clearDatas
{
    self.token = @"";
    self.phoneNum = nil;
    self.userID = 0;
    self.registTime = 0;
    self.email = nil;
    self.userName = nil;
    self.province = nil;
    self.city = nil;
    self.district = nil;
    self.address = nil;
    self.headImg = nil;
    self.headImgH = nil;
    
    [self saveDatas];
}

-(BOOL)isLogin
{
    if (_token.length > 0) {
        return YES;
    }
    return NO;
}


#pragma mark - NSCoding


/**
 *  解档协议方法
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.oldLoginStr = [coder decodeObjectForKey:@"oldLoginStr"];
        self.token = [coder decodeObjectForKey:@"token"];
        
        self.userID = [coder decodeIntegerForKey:@"userID"];
        self.phoneNum = [coder decodeObjectForKey:@"phoneNum"];
        self.registTime = [coder decodeDoubleForKey:@"registTime"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.address = [coder decodeObjectForKey:@"address"];
        self.province = [coder decodeObjectForKey:@"province"];
        self.city = [coder decodeObjectForKey:@"city"];
        self.district = [coder decodeObjectForKey:@"district"];
        self.headImg = [coder decodeObjectForKey:@"headImg"];
        self.headImgH = [coder decodeObjectForKey:@"headImgH"];
    
        self.password = [coder decodeObjectForKey:@"password"];
    }
    return self;
}

/**
 *  归档协议方法
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_oldLoginStr forKey:@"oldLoginStr"];
    [aCoder encodeObject:_token forKey:@"token"];
    
    
    [aCoder encodeInteger:_userID forKey:@"userID"];
    [aCoder encodeDouble:_registTime forKey:@"registTime"];
    [aCoder encodeObject:_phoneNum forKey:@"phoneNum"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_province forKey:@"province"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_district forKey:@"district"];
    [aCoder encodeObject:_headImg forKey:@"headImg"];
    [aCoder encodeObject:_headImgH forKey:@"headImgH"];
    
    
    [aCoder encodeObject:_password forKey:@"password"];
}

#pragma mark - Screen

-(CGFloat)screenScaleH
{
    if (_scaleH == 0) {
        _scaleH = kScreenH / 667.0f;
    }
    return _scaleH;
}

-(CGFloat)screenScaleW
{
    if (_scaleW == 0) {
        _scaleW = kScreenW / 375.0f;
    }
    return _scaleW;
}


@end
