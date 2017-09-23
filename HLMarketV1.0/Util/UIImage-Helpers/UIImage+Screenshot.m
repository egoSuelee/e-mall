//
//  UIImage+Screenshot.m
//  NZAlertView
//
//  Created by Bruno Furtado on 20/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#import "UIImage+Screenshot.h"

@implementation UIImage (Screenshot)

+ (UIImage *)screenshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);

            CGContextTranslateCTM(context, [window center].x, [window center].y);

            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)theViewShot:(UIView *)theView{
    //************** 得到图片 *******************
    CGRect rect = theView.frame;  //截取图片大小
    
    //开始取图，参数：截图图片大小,透明度，比例
    UIGraphicsBeginImageContextWithOptions(rect.size, theView.opaque, 0.0);
    //截图层放入上下文中
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //从上下文中获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束截图
    UIGraphicsEndImageContext();
    return image;
}

@end
