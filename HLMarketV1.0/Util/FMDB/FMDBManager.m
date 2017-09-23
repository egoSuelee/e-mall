//
//  FMDBManager.m
//  营运通
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 www.warelucent.com. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager ()
{
    FMDatabase *_fmdb;
}
@end

static FMDBManager *_manager = nil;

@implementation FMDBManager

+ (instancetype)shareManager
{
    if (!_manager) {
        _manager = [[FMDBManager alloc] init];
    }
    
    return _manager;
}

- (instancetype)init{
    if (self = [super init]) {
        // 数据库路径
        NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/HLMark.db"];
        // 1.创建fmdb对象,需要指定数据库路径
        _fmdb = [FMDatabase databaseWithPath:dbPath];
        // 2.打开数据库 open方法:如果数据库没有存在,先创建一个数据库。如果已经存在,直接打开
        if (![_fmdb open]) {
            
        }
    }
    return self;
}

- (NSMutableArray *)getDBDataFrom:(NSString *)DBName
{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@",DBName];
    
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    while ([set next]) {
        
        NSDictionary *dataDic = [set resultDictionary];
        
        [dataArr addObject:dataDic];
    }
    
    return dataArr;
}

- (NSMutableArray *)getDBDataWithSQL:(NSString *)sql
{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    while ([set next]) {
        
        NSDictionary *dataDic = [set resultDictionary];
        
        [dataArr addObject:dataDic];
    }
    
    return dataArr;
}

- (BOOL)deleteDBDataFrom:(NSString *)DBName{
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@",DBName];
    
    BOOL isSuccess = [_fmdb executeUpdate:sql];
    
    return isSuccess;
}

- (BOOL)executeDBSQLArr:(NSArray *)sqlArr{
    
    BOOL isSuccess = NO;
    
    for (int i = 0; i<sqlArr.count; i++) {
        isSuccess = [_fmdb executeUpdate:sqlArr[i]];
        
        if (!isSuccess) {
            return isSuccess;
        }
    }
    
    return isSuccess;
}


- (void)closeDB{
    
    if (_fmdb) {
        [_fmdb close];
    }
    
}

+ (BOOL)resetDB{
    
    // 数据库路径
    NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/HLMark.db"];
    
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    
    return [fileManager removeItemAtPath:dbPath error:nil];
}

@end
