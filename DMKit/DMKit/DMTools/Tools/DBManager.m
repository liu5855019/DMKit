//
//  DBManager.m
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/21.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"


#define kDBFile @"DATAS.db"
#define kTableLocation @"locationtable"
#define kTableLog @"logtable"

@interface DBManager ()

@property (nonatomic , strong) FMDatabase *database;

@end

@implementation DBManager

-(FMDatabase *)database
{
    if (_database == nil) {
        _database = [FMDatabase databaseWithPath:[DMTools filePathInDocuntsWithFile:kDBFile]];
    }
    return _database;
}

+(instancetype)shareDB
{
    static DBManager *manag;
    
    static dispatch_once_t onceDB;
    dispatch_once(&onceDB, ^{
        manag = [[DBManager alloc] init];
        
        if (![manag.database open]) {
            NSLog(@"=error==%@",[manag.database lastErrorMessage]);
            return;
        }
        
        //[manag createLocationTable];
        
        [manag createLogTable];
    });
    return manag;
}

#pragma  mark - << CreateTable >>

//创建表
- (BOOL) createTable:(NSString *)tableName WithPropertys:(NSArray <PropertyModel *> *)proprtys
{
    if (!tableName.length || !proprtys.count) {
        NSLog(@"创建 失败");
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@",tableName];
    
    sql = [sql stringByAppendingString:@"(ID integer primary key"];
    
    for (PropertyModel *model in proprtys) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@",%@ %@",model.name,[self getStringFromPropertyType:model.type]]];
    }
    
    sql = [sql stringByAppendingString:@")"];
    
    NSLog(@"%@",sql);

    BOOL result = [self.database executeUpdate:sql];
    
    if (result == NO) {
        NSLog(@"创建 %@ 表失败!",tableName);
    }
    
    return result;
}

-(NSString *)getStringFromPropertyType:(PropertyType)type
{
    NSString *str = nil;
    
    switch (type) {
        case PT_TEXT:
            str = @"text";
            break;
        case PT_INTEGER:
            str = @"integer";
            break;
        case PT_DOUBLE:
            str = @"double";
            break;
        case PT_BOOL:
            str = @"bool";
            break;
        case PT_DATA:
            str = @"blob";
            break;
        default:
            str = @"text";
            break;
    }
    
    return str;
    
}

-(BOOL)createLocationTable
{
    NSString *sql=@"create table if not exists locationtable(\
        ID integer primary key,\
        time text,          \
        locationStr text,   \
        locationX double,   \
        locationY double,   \
        speed double,       \
        range double,       \
        isBackGround bool,  \
        isSend bool,        \
        userID integer,     \
        userName text       \
    )";
    
    //创建表
    BOOL result= [self.database executeUpdate:sql];
    if (result == NO) {
        NSLog(@"创建 location 表失败");
        NSLog(@"-----error-----:%@",[self.database lastError]);
    }else{
        NSLog(@"创建 location 表成功");
    }
    return result;
}

-(BOOL)createLogTable
{
    NSString *sql=@"create table if not exists logtable(\
    ID integer primary key,\
    time text,          \
    content text,       \
    page text           \
    )";
    
    //创建表
    BOOL result= [self.database executeUpdate:sql];
    if (result == NO) {
        NSLog(@"创建 log 表失败");
        NSLog(@"-----error-----:%@",[self.database lastError]);
    }else{
        NSLog(@"创建 log 表成功");
    }
    return result;
}

#pragma mark - << LocationTable >>

//
//- (BOOL) insertLocationWithLocationModel:(LocationModel *)model
//{
//    BOOL result = [self.database executeUpdate:@"insert into locationtable(time,locationStr,locationX,locationY,speed,range,isBackGround,isSend,userID,userName) values(?,?,?,?,?,?,?,?,?,?)",
//                   model.time,
//                   model.locationStr,
//                   @([model.locationX doubleValue]),
//                   @([model.locationY doubleValue]),
//                   @([model.speed doubleValue]),
//                   @([model.range doubleValue]),
//                   @([model.isBackGround boolValue]),
//                   @([model.isSend boolValue]),
//                   @([UserInfo shareUser].userID),
//                   [UserInfo shareUser].userName ? [UserInfo shareUser].userName : @"未知"] ;
//
//    if (result == NO) {
//        NSLog(@"插入失败");
//    }else{
//        NSLog(@"插入成功");
//    }
//
//    return result;
//}


- (NSMutableArray *)selectAllLocations
{
    FMResultSet *set =[self.database executeQueryWithFormat:@"select * from locationtable"];
    
    NSMutableArray *muarray = [NSMutableArray array];
    
    while ([set next]) {
        NSDictionary *dict = [set resultDictionary];
//        LocationModel *model = [[LocationModel alloc] init];
//
//        model.time = dict[@"time"];
//        model.locationStr = dict[@"locationStr"];
//        model.locationX = [dict[@"locationX"] stringValue];
//        model.locationY = [dict[@"locationY"] stringValue];
//        model.speed = [dict[@"speed"] stringValue];
//        model.range = [dict[@"range"] stringValue];
//        model.isBackGround = [dict[@"isBackGround"] stringValue];
//        model.isSend = [dict[@"isSend"] stringValue];
//        [muarray addObject:model];
        
        [muarray addObject:dict];
    }
    return muarray;
    
}



-(NSMutableArray *) selectNoSendLocation
{
    FMResultSet *set =[self.database executeQueryWithFormat:@"select * from locationtable where isSend = 0"];
    
    NSMutableArray *muarray = [NSMutableArray array];
    
    while ([set next]) {
        NSDictionary *dict = [set resultDictionary];
        [muarray addObject:dict];
    }
    return muarray;
}

/** 查找所有属于当前用户的未发送location */
- (NSMutableArray *)selectAllMyNoSendLocations
{
    FMResultSet *set =[self.database executeQueryWithFormat:@"select * from locationtable where isSend = 0 and userID = %ld",(long)[UserInfo shareUser].userID];
    
    NSMutableArray *muarray = [NSMutableArray array];
    
    while ([set next]) {
        NSDictionary *dict = [set resultDictionary];
        [muarray addObject:dict];
    }
    return muarray;
}

-(BOOL) updateLocationIsSendStateWithID:(NSInteger)ID
{
    BOOL result = [self.database executeUpdateWithFormat:@"update locationtable set isSend = 1 where ID = %ld",(long)ID];
    if (!result) {
        NSLog(@"更新失败");
    }else{
        NSLog(@"更新成功");
    }
    return result;
}
//
///** 删除过期的Locations */
//- (void)deleteLocationsIfTimeOver
//{
//
//    FMResultSet *set = [self.database executeQueryWithFormat:@"select * from locationtable"];
//
//    NSDate *now = [NSDate date];
//
//    while ([set next]) {
//        NSDictionary *result = [set resultDictionary];
//        NSString *timeStr = result[@"time"];
//        NSDate *date = [DateTools dateFromString:timeStr withFormat:yyyyMMddHHmmss];
//        if ([now timeIntervalSinceDate:date] > kDeleteDatasTime ) {
//            [self deleteAtTable:kTableLocation WithID:[result[@"ID"] integerValue]];
//        }
//    }
//}



#pragma mark - << LogTable >>


-(BOOL)insertLogWithPage:(NSString *)page Content:(NSString *)content Date:(NSDate *)date
{
    if (!kIsInsertLogs) { //配置文件是否允许写入日志
        return NO;
    }
    NSString *time = date == nil ? [NSDate date].getStringWithDetailFormatter : date.getStringWithDetailFormatter;
    BOOL result = [self.database executeUpdate:@"insert into logtable(page,content,time) values(?,?,?)",page,content,time];
    
    if (result == NO) {
        NSLog(@"插入log失败");
    }else{
        NSLog(@"插入log成功");
    }
    return result;
}

/** 查询所有Logs */
-(NSMutableArray *)selectAllLogs
{
    FMResultSet *set = [self.database executeQueryWithFormat:@"select * from logtable"];
    
    NSMutableArray *muarray = [NSMutableArray array];
    
    while ([set next]) {
        NSDictionary *result = [set resultDictionary];
        [muarray addObject:result];
    }
    
    return muarray;
}

/** 查询所有今天的logs */
-(NSMutableArray *)selectLogsInToday
{
    FMResultSet *set = [self.database executeQueryWithFormat:@"select * from logtable"];
    
    NSDate *today = [NSDate date];
    NSString *str = [today getStringWithFormat:yyyyMMdd];
    str = [str stringByAppendingString:@" 00:00:00"];
    NSLog(@"%@",str);
    today = [NSDate dateFromString:str withFormat:yyyyMMddHHmmss];
    
    NSMutableArray *muarray = [NSMutableArray array];
    while ([set next]) {
        NSDictionary *result = [set resultDictionary];
        NSString *timeStr = result[@"time"];
        NSDate *date = [NSDate dateFromString:timeStr withFormat:yyyyMMddHHmmss];
        if ([date timeIntervalSinceDate:today] >= 0) {
            [muarray addObject:result];
        }
    }
    return muarray;
}
//删除过期logs
-(void)deleteLogsIfTimeOver
{
    FMResultSet *set = [self.database executeQueryWithFormat:@"select * from logtable"];
    
    NSDate *now = [NSDate date];
    
    while ([set next]) {
        NSDictionary *result = [set resultDictionary];
        NSString *timeStr = result[@"time"];
        NSDate *date = [NSDate dateFromString:timeStr withFormat:yyyyMMddHHmmss];
        if ([now timeIntervalSinceDate:date] > kDeleteDatasTime ) {
            [self deleteAtTable:kTableLog WithID:[result[@"ID"] integerValue]];
        }
    }
}


#pragma mark - << Delete >>

-(BOOL)deleteAtTable:(NSString *)table WithID:(NSInteger)ID
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where ID = %ld",table,(long)ID];
    BOOL result = [self.database executeUpdate:sql];
    if (!result) {
        NSLog(@" 删除失败");
    }else{
        NSLog(@"删除成功--%@--%ld",table,ID);
    }
    return result;
}




@end
