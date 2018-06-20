//
//  FGLanguageTool.h
//  Questionnaire
//
//  Created by 西安旺豆电子 on 2017/10/10.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

//#define kLocStr(key) [[DMLanguageTool sharedInstance] stringWithKey:key]

static NSString * const kUpdateLanguageNoti = @"kUpdateLanguageNoti";

typedef enum : NSUInteger {
    LT_DEFAULT,
    LT_ZH_HANS,
    LT_EN,
} LanguageType;



#import <Foundation/Foundation.h>

@interface DMLanguageTool : NSObject

@property (nonatomic , assign) LanguageType type;

+ (id)sharedInstance;

- (NSString *)stringWithKey:(NSString *)key;

@end

