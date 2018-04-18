//
//  DMExceptionTool.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/4/10.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "DMExceptionTool.h"
#import <execinfo.h>


static NSString * const kUploadCrashUrl = @"http://192.168.100.101:80/addCollapseInfo";


@implementation DMExceptionTool

+ (void)start
{
    static int count = 0;
    count++;
    if (count == 1) {
        //信号量截断
        InstallSignalHandler();
        
        //系统异常捕获
        NSSetUncaughtExceptionHandler(&uncaught_exception_handle);
        
        [self checkFilesAndUpload];
    }
}

#pragma mark - File

+ (NSString *)getDirPath
{
    NSLog(@"Thread : %@",[NSThread currentThread]);
    
    NSString *dirPath = [DMTools filePathInDocuntsWithFile:@"Log"];
    
    [DMTools createDirectory:dirPath];
    
    return dirPath;
}

+ (void)saveCrash:(NSString *)crash
{
    NSString *deviceType = [DMTools getDeviceType];
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *appVersion = kAppVerison;
    NSString *appBuild = kAppBuild;
    NSString *timeStr = [[NSDate date] getStringWithFormat:@"yyyyMMddHHmmss"];
    
    NSString *result = [NSString stringWithFormat:@"DeviceName:%@\nDeviceType:%@\nSystemVersion:%@\nAppName:%@\nBundleID:%@\nAppVersion:%@\nAppBuild:%@\nTime:%@\n\nCrashInfo:\n%@",
                        deviceName,
                        deviceType,
                        systemVersion,
                        appName,
                        bundleID,
                        appVersion,
                        appBuild,
                        timeStr,
                        crash];
    
    NSString *dirPath = [DMExceptionTool getDirPath];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.log",dirPath,timeStr];
    
    [result writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void)checkFilesAndUpload
{
    BACK((^{
        NSLog(@"正在检查crash日志...");
        NSString *dirPath = [self getDirPath];
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
    }));
}

+ (void)uploadFile:(NSString *)fileName
{
    NSLog(@"发现crash日志,正在上传...");
    NSString *dirPath = [self getDirPath];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
    
    NSString *info = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    
    NSDictionary *para = @{
                           @"app_name":bundleID,
                           @"error_info":info
                           };

    [self postWithUrl:kUploadCrashUrl para:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isEqualToString:@"success"]) {
            [DMTools deleteFileAtPath:filePath];
            [self checkFilesAndUpload];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
    [DMExceptionTool saveCrash:mustr];
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
    
    [DMExceptionTool saveCrash:exceptionInfo];
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
