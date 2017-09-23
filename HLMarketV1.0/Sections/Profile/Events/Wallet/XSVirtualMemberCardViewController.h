//
//  XSVirtualMemberCardViewController.h
//  滴购
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface XSVirtualMemberCardViewController : UIViewController

@property (nonatomic, copy) void (^GetCodeBlock)();
@property (nonatomic, copy) void (^LoadScanDataFromServiceBlock)(NSString *code);

@end
