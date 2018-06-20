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


//第三方
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import "MJRefresh.h"
#import "FCUUID.h"
#import "ReactiveObjC.h"





//Tools
#import "DMDefine.h"
#import "DMTools.h"
#import "UserInfo.h"
#import "LocationTool.h"
#import "ImagePickerTool.h"
#import "DBManager.h"
#import "DMExceptionTool.h"



//Base
#import "BaseViewController.h"
#import "BaseNavigationController.h"




//Category  类别
#import "NSObject+DMTools.h"
#import "NSArray+DMTools.h"
#import "NSData+DMTools.h"
#import "NSString+DMTools.h"
#import "NSDate+DMTools.h"

#import "UIViewController+DMTools.h"
#import "UINavigationBar+DMTools.h"
#import "UILabel+DMTools.h"
#import "UIView+DMTools.h"
#import "UIImage+DMTools.h"
#import "UIColor+DMTools.h"

#import "CADisplayLink+DMTools.h"







//Views
#import "DMItemsView.h"
#import "DMSegmentView.h"
#import "DMWebView.h"
#import "DMAlertView.h"
#import "DMBasePickerView.h"
#import "DMPickerView.h"
#import "DMShowBigImageView.h"
#import "DMShadowView.h"








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
#define kIsInsertLogs 1




#endif /* Common_h */
