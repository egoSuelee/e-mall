//
//  HLXMLParser.m
//  隆云
//
//  Created by 彭仁帅 on 2017/2/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HLXMLParser.h"

@interface HLXMLParser ()

@property (copy, nonatomic) NSString *currentTagName;

@end

@implementation HLXMLParser

- (void)startWithXMLStr:(NSString *)str{
    // 开始解析XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    [parser parse];
}

// 文档开始的时候触发
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // 此方法只在解析开始时触发一次，因此可在这个方法中初始化解析过程中用到的一些成员变量
    _notes = [NSMutableDictionary new];
}

// 文档出错的时候触发
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", parseError);
}

// 遇到一个开始标签的时候触发
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _currentTagName = elementName;
}

// 遇到字符串时候触发，该方法是解析元素文本内容主要场所
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // 剔除回车和空格
    // stringByTrimmingCharactersInSet：方法是剔除字符方法
    // [NSCharacterSet whitespaceAndNewlineCharacterSet]指定字符集为换行符和回车符
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
    
    [_notes setObject:string forKey:_currentTagName];
}

// 遇到结束标签时触发，在该方法中主要是清理刚刚解析完成的元素产生的影响，以便于不影响接下来的解析
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
}

// 遇到文档结束时触发
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (self.reloadData) {
        self.reloadData(_notes);
    }
    // 解析完成，清理成员变量
    self.notes = nil;
    
}

@end

