//
//  DMTools.h
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 17/8/31.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTools : NSObject

#pragma mark - << Device & Version >>

/** 获取设备型号 */
+ (NSString *)getDeviceType;

/** 检查版本是否需要更新 */
+ (void)checkVersionWithAppId:(NSString *)appId;


#pragma mark - <<Alert & Sheet & Toast>>

/** 弹出对话框,只有确定按钮 */
+ (void)showAlertWithTitle:(NSString *)title
                andContent:(NSString *)content
                  andBlock:(void (^)(void))todo
                      atVC:(__weak UIViewController *)vc;

/** 弹出对话框,带确定和取消按钮,可定制确定取消的标题 */
+ (void)showAlertWithTitle:(NSString *)title
                andContent:(NSString *)content
              andSureBlock:(void(^)(void))sureTodo
            andCancelBlock:(void(^)(void))cancelTodo
              andSureTitle:(NSString *)sureTitle
            andCancelTitle:(NSString *)cancelTitle
                      atVC:(__weak UIViewController *)vc;

/** 弹出sheet,根据数组弹出不同个数的action,外带取消按钮 */
+(void)showSheetWithTitle:(NSString *)title
               andContent:(NSString *)content
          andActionTitles:(NSArray <NSString*> *)titles
                 andBlock:(void (^)(int index))clickBlock
                     atVC:(__weak UIViewController *)vc;

/** 在window上显示toast */
+ (void)showToastAtWindow:(NSString *)content;

/** 在window上显示toast */
+ (void)showToastAtWindow:(NSString *)content duration:(NSTimeInterval)time position:(id)obj;

#pragma mark - <<Tools>>

/** 检查一个对象是否为空 */
+ (BOOL) checkIsNullObject:(id)anObject;

/** 从一个nsobject中根据属性获得dict 目前只支持字符串类型*/
+ (NSDictionary *) getDictFromObject:(NSObject *)object;

/** 判断是否为中文简体 */
+ (BOOL)isSimpleChinese;

/** 判断是否为英文 */
+ (BOOL)isEnglish;

/** dict or array >>>>> json */
+ (NSString *)getJsonFromDictOrArray:(id)theData;

/** jsonStr >>>>>>> dict or array */
+ (id) getDictOrArrayFromJsonStr:(NSString *)json;

/** 根据起始数字 终点数字 和 持续时间 返回 每秒60次的播放数组 */
+ (NSArray *)getNumsWithFrom:(CGFloat)from To:(CGFloat)to Time:(CGFloat)time;

/** 获取两个坐标的距离 */ 
+ (double)getMeterWithCoord2D:(CLLocationCoordinate2D)coor1
                      Coord2D:(CLLocationCoordinate2D)coor2;

#pragma mark - << NSUserDefults >>

/** 存储用户偏好设置 到 NSUserDefults */
+(void)saveUserData:(id <NSCoding>)data forKey:(NSString*)key;

/** 读取用户偏好设置 */
+(id)readUserDataForKey:(NSString*)key;

/** 删除用户偏好设置*/
+(void)removeUserDataForkey:(NSString*)key;



#pragma mark - << Documents >>
/*
 1、Documents 目录：您应该将所有de应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
 
 2、AppName.app 目录：这是应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动。
 
 3、Library 目录：这个目录下有两个子目录：Caches 和 Preferences
 Preferences 目录：包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
 Caches 目录：用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
 
 4、tmp 目录：这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
 */

/** 给出文件名获得其在doc中的路径 */
+(NSString *)filePathInDocuntsWithFile:(NSString *)file;

/** 给出文件名获得其在Cache中的路径 */
+(NSString *)filePathInCachesWithFile:(NSString *)file;

/** 给出文件名获得其在Tmp中的路径 */
+(NSString *)filePathInTmpWithFile:(NSString *)file;


#pragma mark - << FileManager >>

/** 文件是否存在 */
+ (BOOL)fileExist:(NSString*)path;

/** 目录是否存在 */
+ (BOOL)directoryExist:(NSString*)dirPath;

/** 创建目录 */
+ (BOOL)createDirectory:(NSString*)dirPath;

/** 删除指定路径文件 */
+ (BOOL)deleteFileAtPath:(NSString *)filePath;

/** 删除指定目录 */
+ (BOOL)deleteDirectoryAtPath:(NSString *)dirPath;

/** 给出imageName获得图片  Doc/Photos文件夹下 */
+ (UIImage *)getImageWithImageName:(NSString *)imageName;

/** 给出image和文件名,存储到Doc/Photos文件夹下 */
+ (BOOL)writeImage:(UIImage *)image toFile:(NSString *)fileName;

/** 修正文件乱码 */
+ (void)fixTextFile:(NSString *)oFile toFile:(NSString *)toFile;

#pragma mark - << String >>

/** 字符串是否是空 */
+ (BOOL)stringIsNull:(NSString *)string;

/** 判断字符串是否全为空格 */
+ (BOOL)stringIsAllWithSpace:(NSString *)string;

/** 判断当前字符串跟数组里的字符串是否有相同的 */
+ (BOOL) stringIsInArray:(NSArray *)array WithString:(NSString *)string;

/** 计算文字所占位置大小 */
+(CGRect) getRectByStr:(NSString *)str fontSize:(NSInteger )textSize maxW:(CGFloat)maxWidth maxH:(CGFloat)maxHeight;

/** MD5 */
+ (NSString *)MD5:(NSString *)string;

/** 字符串转拼音 (没试过)*/
+ (NSString *)stringToPinyinWithString:(NSString *)string;

/** 比较版本号大小 : 3.2.1 > 3.2.0    4 > 3.02.1  只有大于才会yes  其他no */
+ (BOOL)version1:(NSString *)str1 greatThanVersion2:(NSString *)str2;



#pragma mark - << 正则匹配 >>

/** 正则匹配邮箱号 */
+ (BOOL)checkMailInput:(NSString *)mail;

/** 正则匹配手机号 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;

/** 正则匹配用户密码6-18位数字和字母组合 */
+ (BOOL)checkPassword:(NSString *) password;

/** 正则匹配密码(3-7位,必须为数字字母都存在,且只有数字字母) */
+ (BOOL)checkPassword2:(NSString *)password;

/** 正则匹配用户身份证号 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;

/** 车牌号验证 */
+ (BOOL) checkCarNumber:(NSString *) CarNumber;


#pragma mark - <<AFNetWorking>>


//Ajax--post提交
/** 重用afn的post */
+ (void)postWithUrl:(NSString *)url
               para:(id)para
            success:(void (^)(id responseObject))success
            failure:(void(^)(NSError *error))failure;

/** 直接获取info 用于特定项目(项目中主要返回值内容全都跟在message里,并且是json型字符串) */
+ (void)postWithUrl:(NSString *)url
               para:(id)para
               info:(void (^)(id info))infomation
            failure:(void(^)(NSError *error))failure;

//Form表单提交, 模仿afn用法
+ (void)postFormWithUrl:(NSString *)url
                   para:(id)para
                success:(void (^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

/** 直接获取message 用于特定项目*/
+ (void)postFormWithUrl:(NSString *)url
                   para:(id)para
                   info:(void (^)(id info))infomation
                failure:(void(^)(NSError *error))failure;


/** 重用afn的get */
+ (void)getWithUrl:(NSString *)url
              para:(id)para
           success:(void (^)(id responseObject))success
           failure:(void(^)(NSError *error))failure;
/** 直接获取message 用于特定项目 */
+ (void)getWithUrl:(NSString *)url
              para:(id)para
              info:(void (^)(id info))infomation
           failure:(void(^)(NSError *error))failure;


/**
 *  请求SOAP，返回NSData
 *
 *  @param url      请求地址
 *  @param soapBody soap的XML中方法和参数段
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)SOAPData:(NSString *)url
        funcName:(NSString *)funcName
        soapBody:(NSString *)soapBody
         success:(void (^)(id responseObject))success
         failure:(void(^)(NSError *error))failure;






@end
