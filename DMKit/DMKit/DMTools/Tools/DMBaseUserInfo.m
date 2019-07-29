//
//  Userid.m
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/6/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//


//
//#import "UserInfo.h"
//
//static NSString * const kUserInfo = @"kUserInfo";
//
//
//@interface UserInfo ()
//
//@property (nonatomic , assign) CGFloat scaleH;
//@property (nonatomic , assign) CGFloat scaleW;
//
//@end
//
//
//@implementation UserInfo
//
//+ (instancetype)shareUser
//{
//    static UserInfo *userInfo;
//    if (userInfo) {
//        return userInfo;
//    }
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *filePath = [DMTools filePathInDocuntsWithFile:kUserInfo];
//        userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//
//        if (!userInfo) {
//            userInfo = [[self alloc] init];
//        }
//    });
//
//    return userInfo;
//}
//
//- (void)saveDatas
//{
//    NSString *filePath = [DMTools filePathInDocuntsWithFile:kUserInfo];
//
//    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
//}
//
//- (void)removeDatas
//{
//    //删除归档的文件
//    NSString *filePath = [DMTools filePathInDocuntsWithFile:kUserInfo];
//    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//}
//
//#pragma mark - NSCoding
//
////  解档协议方法
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super init];
//    if (self) {
//        self.oldUserName = [coder decodeObjectForKey:@"oldUserName"];
//    }
//    return self;
//}
//
//
////  归档协议方法
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.oldUserName forKey:@"oldUserName"];
//}
//
//#pragma mark - Screen
//
//- (CGFloat)screenScaleH
//{
//    if (_scaleH == 0) {
//        _scaleH = kScreenH / 667.0f;
//    }
//    return _scaleH;
//}
//
//- (CGFloat)screenScaleW
//{
//    if (_scaleW == 0) {
//        _scaleW = kScreenW / 375.0f;
//    }
//    return _scaleW;
//}
//
//@end
//
