//
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/6/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


@property (nonatomic , copy) NSString *oldLoginStr;
@property (nonatomic , copy) NSString *token;

@property (nonatomic , assign) NSInteger userID;
@property (nonatomic , copy) NSString *phoneNum;        ///<手机号
@property (nonatomic , assign) double registTime;       ///<注册时间
@property (nonatomic , copy) NSString *email;           ///<邮箱
@property (nonatomic , copy) NSString *userName;        ///<用户名
@property (nonatomic , copy) NSString *address;         ///<详细地址
@property (nonatomic , copy) NSString *province;        ///<省
@property (nonatomic , copy) NSString *city;            ///<市
@property (nonatomic , copy) NSString *district;        ///<区


@property (nonatomic , copy) NSString *password;

@property (nonatomic , copy) NSString *headImg;         ///<头像
@property (nonatomic , copy) NSString *headImgH;        ///<高清版头像




+(instancetype) shareUser;

/** 当用户登录了返回当前用户的token,如果是游客返回 "tourist" */
+(NSString *)token;

/** 写入文件 */
-(void)saveDatas;
/** 删除文件 */
-(void)removeDatas;
/** 清除个人数据 */
-(void)clearDatas;
/** 是否登录状态,根据token值动态计算 */
-(BOOL)isLogin;



//屏幕比例 根据6/6s/7的屏幕计算屏幕比例 配合DMDefine使用
- (CGFloat)screenScaleH;
- (CGFloat)screenScaleW;

@end
