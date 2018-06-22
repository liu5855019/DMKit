//
//  LanguageTool.m
//  Questionnaire
//
//  Created by 西安旺豆电子 on 2017/10/10.
//  Copyright © 2017年 西安旺豆. All rights reserved.
//

#import "DMLanguageTool.h"
#import "AppDelegate.h"


#define LANGUAGE_SET @"langeuageset"



@interface DMLanguageTool()

@property(nonatomic , strong) NSBundle *bundle;

@end

@implementation DMLanguageTool

+ (id)sharedInstance
{
    static DMLanguageTool *sharedModel;
    if (!sharedModel) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedModel = [[DMLanguageTool alloc] init];
        });
    }
    return sharedModel;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initLanguage];
    }
    return self;
}

- (void)initLanguage
{
    NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
    
    self.type = [tmp integerValue];
}


- (NSString *)stringWithKey:(NSString *)key
{
    if (_bundle) {
        return [_bundle localizedStringForKey:key value:nil table:@"Localizable"];
    }
    return NSLocalizedString(key, nil);
}

- (void)setType:(LanguageType)type
{
    _type = type;
    
    self.bundle = [self bundleWithType:type];
    
    [[NSUserDefaults standardUserDefaults] setObject:[@(_type) stringValue] forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLanguageNoti object:nil userInfo:nil];
    
}

- (NSBundle *)bundleWithType:(LanguageType)type
{
    if (type == LT_ZH_HANS) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        return [NSBundle bundleWithPath:path];
    } else if (type == LT_EN) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        return [NSBundle bundleWithPath:path];
    }
    return nil;
}

@end


