//
//  DMTools.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 17/8/31.
//  Copyright © 2017年 呆木出品. All rights reserved.
//

#import "DMTools.h"

#include <objc/runtime.h>

#import <CommonCrypto/CommonDigest.h>   //md5 用到


@implementation DMTools

#pragma mark - <<Alert & Sheet & Toast>>
/** 弹出对话框,只有确定按钮 */
+ (void)showAlertWithTitle:(NSString *)title
                andContent:(NSString *)content
                  andBlock:(void (^)(void))todo
                      atVC:(UIViewController *__weak)vc
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (todo) {
            todo();
        }
    }];
    
    [controller addAction:action];
    
    if (vc == nil) {
        vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    [vc presentViewController:controller animated:YES completion:nil];
}

/** 弹出对话框,带确定和取消按钮,可定制确定取消的标题 */
+ (void)showAlertWithTitle:(NSString *)title
                andContent:(NSString *)content
              andSureBlock:(void(^)(void))sureTodo
            andCancelBlock:(void(^)(void))cancelTodo
              andSureTitle:(NSString *)sureTitle
            andCancelTitle:(NSString *)cancelTitle
                      atVC:(UIViewController *__weak)vc
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    sureTitle = sureTitle.length ? sureTitle : kLocStr(@"确定");
    cancelTitle = cancelTitle.length ? cancelTitle : kLocStr(@"取消");
    UIAlertAction *sureAction = nil;
    
    if ([sureTitle isEqualToString:kLocStr(@"删除")]) {
        sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (sureTodo) {
                sureTodo();
            }
        }];
    }else{
        sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureTodo) {
                sureTodo();
            }
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelTodo) {
            cancelTodo();
        }
    }];
    
    [controller addAction:cancelAction];
    [controller addAction:sureAction];
    
    
    if (vc == nil) {
        vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [vc presentViewController:controller animated:YES completion:nil];
}

/** 弹出sheet,根据数组弹出不同个数的action,外带取消按钮 */
+(void)showSheetWithTitle:(NSString *)title
               andContent:(NSString *)content
          andActionTitles:(NSArray <NSString*> *)titles
                 andBlock:(void (^)(int index))clickBlock
                     atVC:(UIViewController *__weak)vc
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleActionSheet];
    int i = 0;
    for (NSString *actionTitle in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            if (clickBlock) {
                clickBlock(i);
            }
        }];
        i++;
        [alertController addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLocStr(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    
    [alertController addAction:action];
    
    if (vc == nil) {
        vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    if (IS_IPAD) {
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
        popPresenter.sourceView = vc.view;
        popPresenter.sourceRect = vc.view.bounds;
    }
    [vc presentViewController:alertController animated:YES completion:nil];
}

/** 在window上显示toast */
+ (void)showToastAtWindow:(NSString *)content
{
    [[UIApplication sharedApplication].keyWindow makeToast:content];
}
/** 在window上显示toast */
+ (void)showToastAtWindow:(NSString *)content duration:(NSTimeInterval)time position:(id)obj
{
    [[UIApplication sharedApplication].keyWindow makeToast:content duration:time position:obj];
}

#pragma mark - <<Tools>>

/** 检查一个对象是否为空 */
+ (BOOL) checkIsNullObject:(id)anObject
{
    if (!anObject || [anObject isKindOfClass:[NSNull class]]) return YES;
    
    return NO;
}

/** 从一个nsobject中根据属性获得dict */
+ (NSDictionary *) getDictFromObject:(NSObject *)object
{
    unsigned int count;
    
    //获得指向当前类的所有属性的指针
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    NSMutableDictionary *mudict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < count; i++) {
        //获取指向当前类的一个属性的指针
        objc_property_t property = properties[i];
        //获取C字符串属性名
        const char *name = property_getName(property);
        //C字符串转OC字符串
        NSString *propertyName = [NSString stringWithUTF8String:name];
        //通过关键词取值
        id propertyValue = [object valueForKey:propertyName];
        if (!propertyValue) {
            propertyValue = @"";
        }
        [mudict addEntriesFromDictionary:@{propertyName:propertyValue}];
    }
    //记得释放
    free(properties);
    return [mudict copy];
}

/** 判断是否为中文简体 */
+ (BOOL)isSimpleChinese
{
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    if ([language hasPrefix:@"zh-Hans"]) {
        return YES;
    }
    return NO;
}

/** 判断是否为英文 */
+ (BOOL)isEnglish
{
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    if ([language hasPrefix:@"en"]) {
        return YES;
    }
    return NO;
}

/** dict or array >>>>> json */
+ (NSString *)getJsonFromDictOrArray:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"%@",error);
        return nil;
    }
}

/** jsonStr >>>>>>> dict or array */
+ (id) getDictOrArrayFromJsonStr:(NSString *)json
{
    if (!json) {
        return nil;
    }
    NSError *error = nil;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    
    if (object && !error) {
        return object;
    }else{
        NSLog(@"%@",error);
        return nil;
    }
}

/** 根据起始数字 终点数字 和 持续时间 返回 每秒60次的播放数组 */
+ (NSArray *)getNumsWithFrom:(CGFloat)from To:(CGFloat)to Time:(CGFloat)time
{
    NSMutableArray *numberArray = [NSMutableArray array];
    for (NSInteger i = 0; i <= time * 60; i++) {
        float timeValue = i / (time * 60) ;
        CGFloat value = (to - from) * timeValue + from;
        [numberArray addObject:@((NSInteger)value).stringValue];
    }
    return [numberArray copy];
}

#pragma mark - << NSUserDefults >>

/** 存储用户偏好设置 到 NSUserDefults */
+(void)saveUserData:(id <NSCoding>)data forKey:(NSString*)key
{
    if (data){
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

/** 读取用户偏好设置 */
+(id)readUserDataForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

/** 删除用户偏好设置*/
+(void)removeUserDataForkey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}

#pragma mark - << Documents >>

/** 给出文件名获得其在doc中的路径 */
+(NSString *)filePathInDocuntsWithFile:(NSString *)file
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:file];
}

/** 给出文件名获得其在Cache中的路径 */
+(NSString *)filePathInCachesWithFile:(NSString *)file
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:file];
}

/** 给出文件名获得其在Tmp中的路径 */
+(NSString *)filePathInTmpWithFile:(NSString *)file
{
    NSString *path = NSTemporaryDirectory();
    return [path stringByAppendingPathComponent:file];
}

#pragma mark - << FileManager >>

/** 文件是否存在 */
+ (BOOL)fileExist:(NSString*)path
{
    if ([self stringIsNull:path]) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/** 目录是否存在 */
+ (BOOL)directoryExist:(NSString*)dirPath
{
    if ([self stringIsNull:dirPath]) {
        return NO;
    }
    BOOL isDir = YES;
    return [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
}

/** 创建目录 */
+ (BOOL)createDirectory:(NSString*)dirPath
{
    if ([self stringIsNull:dirPath]) {
        return NO;
    }
    if ([self directoryExist:dirPath]) {
        return YES;
    }
    return [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

/** 删除指定路径文件 */
+ (BOOL)deleteFileAtPath:(NSString *)filePath
{
    if ([self stringIsNull:filePath]) {
        return NO;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

/** 删除指定目录 */
+ (BOOL)deleteDirectoryAtPath:(NSString *)dirPath
{
    if ([self stringIsNull:dirPath]) {
        return NO;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:dirPath error:nil];
}

/** 给出imageName获得图片 */
+ (UIImage *)getImageWithImageName:(NSString *)imageName
{
    if ([self stringIsNull:imageName]) {
        return nil;
    }
    NSString *dirPath = [self filePathInDocuntsWithFile:@"Photos"];
    NSString *imagePath = [dirPath stringByAppendingPathComponent:imageName];
    return [UIImage imageWithContentsOfFile:imagePath];
}

/** 给出image和文件名,存储到doc目录 */
+ (BOOL)writeImage:(UIImage *)image toFile:(NSString *)fileName
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //生成文件夹路径
    NSString *dirPath = [self filePathInDocuntsWithFile:@"Photos"];
    //查看文件夹路径存在不,如果不存在创建文件夹,如果创建不成功返回no
    if (![self directoryExist:dirPath]) {
        if (![self createDirectory:dirPath]) {
            return NO;
        }
    }
    //拼接路径
    NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
    return  [imageData writeToFile:filePath atomically:YES];
}

#pragma mark - << String >>

/** 字符串是否是空 */
+ (BOOL)stringIsNull:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (!string || [string isKindOfClass:[NSNull class]] || string.length == 0 || [string isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

/** 判断字符串是否全为空格 */
+ (BOOL)stringIsAllWithSpace:(NSString *)string
{
    if ([self stringIsNull:string]) {
        return YES;
    }else{
        NSString *trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (trimString.length > 0) {
            return NO;
        }else{
            return YES;
        }
    }
}

/** 判断当前字符串跟数组里的字符串是否有相同的 */
+ (BOOL) stringIsInArray:(NSArray *)array WithString:(NSString *)string
{
    for (NSString *string1 in array) {
        if ([string isEqualToString:string1]) {
            return YES;
        }
    }
    return NO;
}

/** 计算文字所占位置大小 */
+(CGRect) getRectByStr:(NSString *)str fontSize:(NSInteger )textSize maxW:(CGFloat)maxWidth maxH:(CGFloat)maxHeight
{
    return [str boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textSize]}
                             context:nil];
}

/** MD5 */
+ (NSString *)MD5:(NSString *)string
{
    const char* aString = [string UTF8String];
    unsigned char result[16];
    CC_MD5(aString, (unsigned int)strlen(aString), result);
    NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
    return [hash lowercaseString];
}

/** 字符串转拼音 */
+ (NSString *)stringToPinyinWithString:(NSString *)string
{
    NSMutableString *str = [string mutableCopy];
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - << 正则匹配 >>

/** 正则匹配邮箱号 */
+ (BOOL)checkMailInput:(NSString *)mail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

/** 正则匹配手机号 */
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,183,185,186,176
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[356]|76)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/** 正则匹配用户密码6-18位数字和字母组合 */
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}

/** 正则匹配密码(3-7位,必须为数字字母都存在,且只有数字字母) */
+ (BOOL)checkPassword2:(NSString *)password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{3,7}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}

/** 正则匹配用户身份证号 */
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [pred evaluateWithObject:idCard];
}

/** 车牌号验证 */
+ (BOOL) checkCarNumber:(NSString *) CarNumber
{
    NSString *bankNum = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    return [pred evaluateWithObject:CarNumber];
}


#pragma mark - <<AFNetWorking>>


//Ajax--post提交
/** 重用afn的post */
+ (void)postWithUrl:(NSString *)url
               para:(id)para
            success:(void (^)(id responseObject))success
            failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        // 得到字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        if (error)
        {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            MAIN(^{
                if (success) {
                    success(result);
                }
            });
        }
        else
        {
            MAIN(^{
                if (success) {
                    success(dict);
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MAIN(^{
            if (failure) {
                failure(error);
            }
        });
    }];
}

/** 直接获取info 用于特定项目(项目中主要返回值内容全都跟在message里,并且是json型字符串) */
+ (void)postWithUrl:(NSString *)url
               para:(id)para
               info:(void (^)(id info))infomation
            failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:url para:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (infomation) {
                infomation(nil);
            }
            return ;
        }
        NSInteger state = [responseObject[@"status"] integerValue];
        if (state == 200) {
            NSString *infoStr = responseObject[@"message"];
            infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
            infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
            NSDictionary *info = [self getDictOrArrayFromJsonStr:infoStr];
            if (infomation) {
                infomation(info);
            }
        }else{
            if (infomation) {
                infomation(responseObject[@"message"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//Form表单提交, 模仿afn用法
+ (void)postFormWithUrl:(NSString *)url
                   para:(id)para
                success:(void (^)(id responseObject))success
                failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key in para) {
            id object = [para valueForKey:key];
            
            if ([object isKindOfClass:[NSString class]]) {
                [formData appendPartWithFormData:[object dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }else if ([object isKindOfClass:[NSNumber class]]){
                [formData appendPartWithFormData:[[object stringValue] dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }else{
                
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        // 得到字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        if (error)
        {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            MAIN(^{
                if (success) {
                    success(result);
                }
            });
        }
        else
        {
            MAIN(^{
                if (success) {
                    success(dict);
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MAIN(^{
            if (failure) {
                failure(error);
            }
        });
    }];
}

/** 直接获取message 用于特定项目*/
+ (void)postFormWithUrl:(NSString *)url
                   para:(id)para
                   info:(void (^)(id info))infomation
                failure:(void(^)(NSError *error))failure
{
    [self postFormWithUrl:url para:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (infomation) {
                infomation(nil);
            }
            return ;
        }
        NSInteger state = [responseObject[@"status"] integerValue];
        if (state == 200) {
            NSString *infoStr = responseObject[@"message"];
            infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
            infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
            NSDictionary *info = [self getDictOrArrayFromJsonStr:infoStr];
            if (infomation) {
                infomation(info);
            }
        }else{
            if (infomation) {
                infomation(responseObject[@"message"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/** 重用afn的get */
+ (void)getWithUrl:(NSString *)url
              para:(id)para
           success:(void (^)(id responseObject))success
           failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        // 得到字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        if (error)
        {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            MAIN(^{
                if (success) {
                    success(result);
                }
            });
        }
        else
        {
            MAIN(^{
                if (success) {
                    success(dict);
                }
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MAIN(^{
            if (failure) {
                failure(error);
            }
        });
    }];
}
/** 直接获取message 用于特定项目 */
+ (void)getWithUrl:(NSString *)url
              para:(id)para
              info:(void (^)(id info))infomation
           failure:(void(^)(NSError *error))failure
{
    [self getWithUrl:url para:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (infomation) {
                infomation(nil);
            }
            return ;
        }
        NSInteger state = [responseObject[@"status"] integerValue];
        if (state == 200) {
            NSString *infoStr = responseObject[@"message"];
            infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
            infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
            NSDictionary *info = [self getDictOrArrayFromJsonStr:infoStr];
            if (infomation) {
                infomation(info);
            }
        }else{
            if (infomation) {
                infomation(responseObject[@"message"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


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
         failure:(void(^)(NSError *error))failure
{
    //    NSString *soapStr1 = [NSString stringWithFormat:
    //                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
    //                         <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\
    //                         xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
    //                         <soap:Header>\
    //                         </soap:Header>\
    //                         <soap:Body>%@</soap:Body>\
    //                         </soap:Envelope>",soapBody];
    
    NSString *soapStr = [NSString stringWithFormat:
                         @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"           \
                         xmlns:q0=\"http://webservice.test.org/\"          \
                         xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"    \
                         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"> \
                         <soapenv:Body>                                    \
                         <q0:%@>                                           \
                         <arg0>%@</arg0>                                   \
                         </q0:%@>                                          \
                         </soapenv:Body>                                   \
                         </soapenv:Envelope>",
                         funcName,soapBody,funcName
                         ];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapStr.length] forHTTPHeaderField:@"Content-Length"];
    
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapStr;
    }];
    
    
    [manager POST:url parameters:soapStr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // 利用正则表达式取出<return></return>之间的字符串
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"(?<=return\\>).*(?=</return)" options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSDictionary *dict = [NSDictionary dictionary];
        for (NSTextCheckingResult *checkingResult in [regular matchesInString:result options:0 range:NSMakeRange(0, result.length)]) {
            
            NSError *error;
            // 得到字典
            dict = [NSJSONSerialization JSONObjectWithData:[[result substringWithRange:checkingResult.range] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            
            if (error) {
                dict = (NSDictionary*)[result substringWithRange:checkingResult.range];
            }
            
        }
        // 请求成功并且结果有值把结果传出去
        MAIN(^{
            if (success) {
                success(dict);
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MAIN(^{
            if (failure) {
                failure(error);
            }
        });
    }];
}






@end
