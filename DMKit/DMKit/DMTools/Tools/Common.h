//
//  Common.h
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/7/12.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#ifndef Common_h
#define Common_h


#import "AppDelegate.h"


#import "DMDefine.h"
#import "DMTools.h"
#import "UserInfo.h"

#import "BaseViewController.h"
#import "BaseNavigationController.h"

//Category  类别
#import "UIViewController+DMTools.h"
#import "UINavigationBar+DMTools.h"
#import "NSArray+DMTools.h"

//第三方
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import "MJRefresh.h"

//#import "MyTools.h"
//#import "DateTools.h"
//#import "UserInfo.h"
//#import "UITools.h"
//#import "DBManager.h"


//#import "BaseViewController.h"










#pragma mark - 消除@selector警告
#define CleanPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



#pragma mark - config



/** 删除过期数据:过期时间(s) */
#define kDeleteDatasTime (3*24*3600)
//是否写入日志
#define kIsInsertLogs 0




#endif /* Common_h */