//
//  FMDBManager.h
//  营运通
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 www.warelucent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface FMDBManager : NSObject

+ (instancetype)shareManager;

- (void)closeDB;

+ (BOOL)resetDB;

- (NSMutableArray *)getDBDataFrom:(NSString *)DBName;

- (NSMutableArray *)getDBDataWithSQL:(NSString *)sql;

- (BOOL)deleteDBDataFrom:(NSString *)DBName;

- (BOOL)executeDBSQLArr:(NSArray *)sqlArr;

@end
