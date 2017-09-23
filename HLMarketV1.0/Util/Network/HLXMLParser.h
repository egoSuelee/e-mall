//
//  HLXMLParser.h
//  隆云
//
//  Created by 彭仁帅 on 2017/2/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLXMLParser : NSObject <NSXMLParserDelegate>
// 解析出的数据
@property (strong, nonatomic) NSMutableDictionary *notes;

@property (strong, nonatomic) void (^reloadData)(NSDictionary *notes);

// 开始解析
- (void)startWithXMLStr:(NSString *)str;
@end
