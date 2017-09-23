//
//  XMLNetWork.h
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/20.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLNetWork : NSObject

+(void)postxmlWithUrl:(NSString *)urlString dataDic:(NSDictionary *)dic andState:(void(^)(BOOL State, NSDictionary *result))xmlStateBlock;

@end
