//
//  DBManager.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/21.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PT_TEXT,
    PT_INTEGER,
    PT_DOUBLE,
    PT_BOOL,
    PT_DATA
} PropertyType;

@interface PropertyModel : NSObject

@property (nonatomic , strong) NSString *name;
@property (nonatomic , assign) PropertyType type;

@end

@class LocationModel;
@interface DBManager : NSObject

+(instancetype)shareDB;

- (BOOL) createTable:(NSString *)tableName WithPropertys:(NSArray <PropertyModel *> *)proprtys;




#pragma mark - << Locations >>
//
//- (BOOL) insertLocationWithLocationModel:(LocationModel *)model;
////查找所有
//- (NSMutableArray *)selectAllLocations;
////查找没有发送的
//- (NSMutableArray *) selectNoSendLocation;
///** 查找所有属于当前用户的未发送location */
//- (NSMutableArray *)selectAllMyNoSendLocations;
////更改发送状态为yes
//- (BOOL) updateLocationIsSendStateWithID:(NSInteger)ID;
///** 删除过期的Locations */
//- (void)deleteLocationsIfTimeOver;

#pragma mark - << Logs >>

/** 写入log */
-(BOOL)insertLogWithPage:(NSString *)page Content:(NSString *)content Date:(NSDate *)date;

/** 查询所有Logs */
-(NSMutableArray *)selectAllLogs;
/** 查询所有今天的logs */
-(NSMutableArray *)selectLogsInToday;
/** 删除过期logs */
-(void)deleteLogsIfTimeOver;

@end
