//
//  DMExceptionTool.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/10.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "DMExceptionTool.h"
#import <execinfo.h>

#define kLogDir @"Log/Log"
#define kCrashDir @"Log/Crash"



static NSString * const kUploadCrashUrl = @"http://192.168.100.212:8090/addCollapseInfo";

@interface DMExceptionTool ()

@property (nonatomic , assign) BOOL isUploading;

@property (nonatomic , strong) NSFileHandle *fileHandle;

@end


@implementation DMExceptionTool

+ (instancetype)shareTool
{
    static DMExceptionTool *exceptionTool;
    if (exceptionTool) {
        return exceptionTool;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!exceptionTool) {
            exceptionTool = [[self alloc] init];
        }
    });
    return exceptionTool;
}

+ (void)start
{
    static int count = 0;
    count++;
    if (count == 1) {
        //信号量截断
        InstallSignalHandler();
        
        //系统异常捕获
        NSSetUncaughtExceptionHandler(&uncaught_exception_handle);
        
        [self startLogger];
        
        [self checkFilesAndUpload];
    }
}

+ (BOOL)isUploading
{
    return [[self shareTool] isUploading];
}

+ (void)setIsUploading:(BOOL)isUploading
{
    return [[self shareTool] setIsUploading:isUploading];
}

+ (void)startLogger
{
    NSString *dirPath = [self getLogDirPath];
    NSString *filePath1 = [NSString stringWithFormat:@"%@/%@.log",dirPath,[FCUUID uuid]];
    [@"" writeToFile:filePath1 atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath1];
    if (handle) {
        [[self shareTool] setFileHandle:handle];
    } else {
        NSLog(@"生成handle失败");
    }
    
    NSError *err = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&err];
    
    if (err) {
        NSLog(@"%@",err);
    } else {
        for (NSString *fileName in files) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
            if (![filePath isEqualToString:filePath1] && [DMTools fileExist:filePath]) {
                NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                if ([content rangeOfString:kNeedUoloadID].length) {
                    [DMExceptionTool sendInfo:content code:@"000000000003" desc:@"上报日志"];
                }
                [DMTools deleteFileAtPath:filePath];
            }
        }
    }
}

+ (void)writeLog:(NSString *)log
{
    NSFileHandle *handle = [[DMExceptionTool shareTool] fileHandle];
    if (handle) {
        [handle seekToEndOfFile];
        [handle writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        NSLog(@"no handle");
    }
}


#pragma mark - save
+ (void)sendInfo:(id)info code:(NSString *)code desc:(NSString *)desc
{
    NSString *crash = @"";
    if ([info isKindOfClass:[NSString class]]) {
        crash = info;
    } else if ([info isKindOfClass:[NSDictionary class]] ||
               [info isKindOfClass:[NSArray class]]) {
        crash = [DMTools getJsonFromDictOrArray:info];
    } else if (info) {
        crash = [NSString stringWithFormat:@"%@",info];
    }
    
    [self saveCrash:crash code:code desc:desc];
    [self checkFilesAndUpload];
}

+ (void)saveCrash:(NSString *)crash code:(NSString *)code desc:(NSString *)desc
{
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSDictionary *para = @{
                           @"deviceType":[DMTools getDeviceType],
                           @"deviceName":[[UIDevice currentDevice] name],
                           @"systemVersion":[[UIDevice currentDevice] systemVersion],
                           @"appName":appName ? appName : @"",
                           @"bundleID":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"],
                           @"appVersion": kAppVerison,
                           @"appBuild":kAppBuild,
                           @"time":[[NSDate date] getStringWithFormat:yyyyMMddHHmmss],
                           @"info":crash,
                           @"code":code,
                           @"desc":desc
                           };
    
    NSString *json = [DMTools getJsonFromDictOrArray:para];
    
    NSString *dirPath = [DMExceptionTool getCrashDirPath];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.log",dirPath,[FCUUID uuid]];
    
    [json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - upload

+ (void)checkFilesAndUpload
{
    if ([self isUploading]) {
        return;
    }
    BACK((^{
        [self setIsUploading:YES];
        NSLog(@"正在检查crash日志...");
        NSString *dirPath = [self getCrashDirPath];
        NSError *err = nil;
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&err];
        
        if (err) {
            NSLog(@"%@",err);
        } else {
            for (NSString *fileName in files) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
                if ([DMTools fileExist:filePath]) {
                    [self uploadFile:fileName];
                    return;
                }
            }
        }
        NSLog(@"未发现crash日志.");
        [self setIsUploading:NO];
    }));
}

+ (void)uploadFile:(NSString *)fileName
{
    NSLog(@"发现crash日志,正在上传...");
    
    NSString *filePath = [self getCrashPathWithFileName:fileName];
    
    NSString *json = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *para = [DMTools getDictOrArrayFromJsonStr:json];
    
    if (para) {
        [self uploadWithErrorcode:para[@"code"] info:json desc:para[@"desc"] happenTime:para[@"time"] remark:@"" filePath:filePath];
    } else {
        [DMTools deleteFileAtPath:filePath];
        [self checkFilesAndUpload];
    }
}


+ (void)uploadWithErrorcode:(NSString *)code
                       info:(NSString *)info
                       desc:(NSString *)desc
                 happenTime:(NSString *)time
                     remark:(NSString *)remark
                   filePath:(NSString *)filePath
{
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSDictionary *para = @{
                           @"app_name":bundleID.length  ? bundleID : @"(null)",
                           @"error_code":code.length? code : @"(null)",
                           @"error_info":info.length ? info : @"(null)",
                           @"error_desc":desc.length ? desc : @"(null)",
                           @"happen_time":time.length ? time : [[NSDate date] getStringWithDetailFormatter],
                           @"remark":remark.length ? remark :@"(null)"
                           };
    
    [self postWithUrl:kUploadCrashUrl para:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isEqualToString:@"success"]) {
            if (filePath.length) {
                BOOL result = [DMTools deleteFileAtPath:filePath];
                NSLog(@"删除文件: %@",result ? @"成功" : @"失败");
            }
            [self setIsUploading:NO];
            [self checkFilesAndUpload];
        } else {
            [self setIsUploading:NO];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self setIsUploading:NO];
    }];
}



#pragma mark - File

//获取文件夹路径
+ (NSString *)getDirPath:(NSString *)file
{
    NSString *dirPath = [DMTools filePathInDocuntsWithFile:file];
    BOOL result = [DMTools createDirectory:dirPath];
    if (!result) {
        NSLog(@"创建文件夹 %@ : %@",file,@"失败");
    }
    return dirPath;
}

+ (NSString *)getLogDirPath
{
    return [self getDirPath:kLogDir];
}

+ (NSString *)getCrashDirPath
{
    return [self getDirPath:kCrashDir];
}

+ (NSString *)getLogPathWithFileName:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@/%@",[self getLogDirPath],fileName];
}

+ (NSString *)getCrashPathWithFileName:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@/%@",[self getCrashDirPath],fileName];
}

#pragma mark - Signal  信号出错

void InstallSignalHandler(void)
{
    //在用户终端连接(正常或非正常)结束时发出
    signal(SIGHUP, SignalExceptionHandler);
    
    //程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl-C)时发出，用于通知前台进程组终止进程。
    signal(SIGINT, SignalExceptionHandler);
    
    //和SIGINT类似, 但由QUIT字符(通常是Ctrl-)来控制
    signal(SIGQUIT, SignalExceptionHandler);
    
    //调用abort()函数生成的信号。
    signal(SIGABRT, SignalExceptionHandler);
    
    //执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号
    signal(SIGILL, SignalExceptionHandler);
    
    //试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据.(地址合法,不属于自己)
    signal(SIGSEGV, SignalExceptionHandler);
    
    //在发生致命的算术运算错误时发出.
    signal(SIGFPE, SignalExceptionHandler);
    
    //访问非法地址
    signal(SIGBUS, SignalExceptionHandler);
    
    //管道破裂。这个信号通常在进程间通信产生
    signal(SIGPIPE, SignalExceptionHandler);
}

void SignalExceptionHandler(int signal)
{
    NSMutableString *mustr = [[NSMutableString alloc] init];
    [mustr appendString:[NSString stringWithFormat:@"Stack: %d \n",signal]];
    void* callstack[128];
    
    //backtrace函数用于获取堆栈的地址信息
    int frames = backtrace(callstack, 128);
    
    //backtrace_symbols函数把堆栈地址翻译成我们易识别的字符串
    char** strs = backtrace_symbols(callstack, frames);
    
    for (int i = 0; i < frames; ++i) {
        [mustr appendFormat:@"%s\n", strs[i]];
    }
    
    free(strs);
    
    NSLog(@"%@",mustr);
    DMLog(@"%@",mustr);
    DMLog(kNeedUoloadID);
    [DMExceptionTool saveCrash:mustr code:@"000000000001" desc:@"信号量导致崩溃"];
    exit(0);
}


#pragma mark - Exception

void uncaught_exception_handle(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    NSLog(@"%@", exceptionInfo);
    
    DMLog(@"%@",exceptionInfo);
    DMLog(kNeedUoloadID);
    
    [DMExceptionTool saveCrash:exceptionInfo code:@"000000000000" desc:@"异常崩溃"];
    exit(0);
}

#pragma mark - NetTool

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
        
        if (error) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (success) {
                success(result);
            }
        } else {
            if (success) {
                success(dict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
