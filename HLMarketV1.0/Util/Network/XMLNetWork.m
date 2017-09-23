//
//  XMLNetWork.m
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/20.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

#import "XMLNetWork.h"
#import "HLXMLParser.h"

@implementation XMLNetWork

+(void)postxmlWithUrl:(NSString *)urlString dataDic:(NSDictionary *)dic andState:(void(^)(BOOL State, NSDictionary *result))xmlStateBlock
{
    //prepar request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //create the body
    NSMutableData *postBody = [NSMutableData data];
    
    for (int i = 0 ; i<dic.allKeys.count; i++) {
        
        if (i==0) {
            [postBody appendData:[[NSString stringWithFormat:@"<xml>"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [postBody appendData:[[NSString stringWithFormat:@"<%@>%@</%@>",dic.allKeys[i],dic[dic.allKeys[i]],dic.allKeys[i]] dataUsingEncoding:NSUTF8StringEncoding]];
        if (i==dic.allKeys.count-1) {
            [postBody appendData:[[NSString stringWithFormat:@"</xml>"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }
    
    //NSString *srr = [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",srr);
    
    //post
    [request setHTTPBody:postBody];
    //get response
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //    NSLog(@"Response Code: %ld", (long)[urlResponse statusCode]);
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        //        NSLog(@"Response: %@", result);
        
        HLXMLParser *parser = [HLXMLParser new];
        [parser setReloadData:^(NSDictionary *notes) {
            
            if (xmlStateBlock) {
                xmlStateBlock(YES,notes);
            }
            
        }];
        // 开始解析
        [parser startWithXMLStr:result];
        
    }else {
        if (xmlStateBlock) {
            xmlStateBlock(NO,nil);
        }
    }
}


@end
