//
//  XSVirtualMemberCardViewController.m
//  滴购
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//


#import "XSVirtualMemberCardViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HLMarketV1_0-Swift.h"

#define kThemeColor [UIColor colorWithRed:223 / 255.0 green:24 / 255.0 blue:37 / 255.0 alpha:1.0];

//NSString * const protocol = @"http";
//NSString * const address  = @"localhost";
//NSString * const port     = @"3000";

@interface XSVirtualMemberCardViewController ()
{
    BOOL           _isShow;
    NSTimer        *_timer;
    NSString       *_oldCode;
}


@property (strong, nonatomic) NSString *code;
@property (assign, nonatomic) CGFloat  currentBrightness;

@property (weak, nonatomic)   IBOutlet UIView         *broadcastView;
@property (weak, nonatomic)   IBOutlet UIScrollView   *scrollView;
@property (strong, nonatomic)          UILabel        *adContentLabel;
@property (strong, nonatomic)          NSTimer        *scrollTimer;

@property (weak, nonatomic)   IBOutlet UIButton       *accessButton;

@property (weak, nonatomic)   IBOutlet UIView         *rectView;
@property (weak, nonatomic)   IBOutlet UIImageView    *barCodeImageView;
@property (weak, nonatomic)   IBOutlet UIImageView    *qrCodeImageView;
@property (weak, nonatomic)   IBOutlet UILabel        *barCodeLabel;

@property (strong, nonatomic)          UIView         *barCodeContentView;
@property (strong, nonatomic)          UIView         *qrCodeContentView;
@property (strong, nonatomic)          UIImageView    *barCodeSizeImageView;
@property (strong, nonatomic)          UIImageView    *qrCodeSizeImageView;
@property (strong, nonatomic)          UILabel        *barCodeSizeLabel;

@property (weak, nonatomic)   IBOutlet UIProgressView *progressView;
@property (strong, nonatomic)          NSTimer        *progressTimer;

@property (strong, nonatomic)          NSDictionary   *jsonDict;

@end

@implementation XSVirtualMemberCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    #pragma mark -- 添加接受数居通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataFromService1:) name:@"RoloadWalletCodeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadScanDataFromService1:) name:@"LoadScanDataFromServiceNotification" object:nil];
    
    /**
     *  设置导航栏
     */
    self.navigationItem.title = @"付款码";
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"] style:UIBarButtonItemStyleDone target:self action:@selector(reloadQRCodeAndBarCode)];
    self.navigationItem.rightBarButtonItem = refreshButtonItem;
//
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//    self.navigationController.navigationBar.backgroundColor = kThemeColor;
//    self.navigationController.navigationBar.barTintColor = kThemeColor;
    /**
     *  设置广播栏
     */
    // 禁止手动滚动
    _scrollView.scrollEnabled = NO;
    _adContentLabel = [[UILabel alloc] init];
    _adContentLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _adContentLabel.text = @"尊敬的乐家优鲜超市用户，感谢您的使用!";
    _adContentLabel.frame = CGRectMake(0, 0, [_adContentLabel.text length]*12, 34);
    [_scrollView addSubview:_adContentLabel];
    _scrollView.contentSize = _adContentLabel.frame.size;
    
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    // 添加事件
    _broadcastView.userInteractionEnabled = YES;
    [_broadcastView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
    
    _accessButton.tintColor = kThemeColor;
    
    /**
     *  设置条形码和二维码
     */
    _qrCodeContentView = [[UIImageView alloc] init];
    _qrCodeImageView.userInteractionEnabled = YES;
    _barCodeContentView = [[UIImageView alloc] init];
    _barCodeImageView.userInteractionEnabled = YES;
    
    /**
     *  设置进度条
     */
    _progressView.trackTintColor = [UIColor colorWithRed:214 / 255.0 green:214 / 255.0 blue:214 / 255.0 alpha:1.0];
    _progressView.progressTintColor = kThemeColor;
    
    /**
     *  加载数据
     */
    [self loadQRCodeAndBarCode];
    
    /**
     *  加载定时器请求编码是否被使用
     */
    _isShow = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadScanDataFromService) userInfo:nil repeats:YES];
    [_timer fire];
    
}

#pragma mark - 点击
- (IBAction)click:(id)sender {
    NSLog(@"click");
}

- (void)tapQRCodeBigger
{
    _currentBrightness = [UIScreen mainScreen].brightness;
    
    // 调整屏幕亮度
    [[UIScreen mainScreen] setBrightness:1.0];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;

    // 创建全屏背景图
    _qrCodeContentView.frame = [UIScreen mainScreen].bounds;
    _qrCodeContentView.backgroundColor = [UIColor whiteColor];

    // 创建image view
    _qrCodeSizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _qrCodeImageView.frame.size.width * 1.2, _qrCodeImageView.frame.size.height * 1.2)];
    _qrCodeSizeImageView.center = CGPointMake(_qrCodeContentView.frame.size.width / 2.0, _qrCodeContentView.frame.size.height / 2.0);
    _qrCodeSizeImageView.image = [UIImage imageWithCIImage:[_qrCodeImageView.image CIImage]];
    [_qrCodeContentView addSubview:_qrCodeSizeImageView];
    
    [self.view addSubview:_qrCodeContentView];
    [self.view bringSubviewToFront:_qrCodeContentView];
    
    _qrCodeContentView.userInteractionEnabled = YES;
    [_qrCodeContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQRCodeSmaller)]];
}

- (void)tapQRCodeSmaller
{
    self.navigationController.navigationBarHidden = NO;
    [_qrCodeContentView removeFromSuperview];
    [_qrCodeSizeImageView removeFromSuperview];
    [[UIScreen mainScreen] setBrightness:_currentBrightness];
}

- (void)tapBarCodeBigger
{
//    _currentBrightness = [UIScreen mainScreen].brightness;
//    // 调整屏幕亮度
//    [[UIScreen mainScreen] setBrightness:1.0];
//
//    // 隐藏导航栏
//    self.navigationController.navigationBarHidden = YES;
//    
//    // 创建全屏背景图
//    _barCodeContentView.frame = [UIScreen mainScreen].bounds;
//    _barCodeContentView.backgroundColor = [UIColor whiteColor];
//    
//    // 创建image view
//    _barCodeSizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _barCodeImageView.frame.size.height * 1.5, _barCodeImageView.frame.size.width * 1.5)];
//    _barCodeSizeImageView.center = CGPointMake(_barCodeContentView.frame.size.width / 2.0, _barCodeContentView.frame.size.height / 2.0);
//    _barCodeSizeImageView.image = [UIImage imageWithCIImage:[_barCodeImageView.image CIImage] scale:1.0 orientation:UIImageOrientationRight];
//    [_barCodeContentView addSubview:_barCodeSizeImageView];
//
//    // 创建label
//    _barCodeSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _barCodeSizeImageView.frame.size.height, 44)];
//    _barCodeSizeLabel.textAlignment = NSTextAlignmentCenter;
//    _barCodeSizeLabel.center = CGPointMake(_barCodeSizeImageView.center.x - 60, _barCodeSizeImageView.center.y);
//    _barCodeSizeLabel.text = [self formatCode:_code];
//    _barCodeSizeLabel.transform = CGAffineTransformMakeRotation(M_PI / 2);
//    [_barCodeContentView addSubview:_barCodeSizeLabel];
//    
//    [self.view addSubview:_barCodeContentView];
//    [self.view bringSubviewToFront:_barCodeContentView];
//    
//    _barCodeContentView.userInteractionEnabled = YES;
//    [_barCodeContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBarCodeSmaller)]];
}

- (void)tapBarCodeSmaller
{
    self.navigationController.navigationBarHidden = NO;
    [_barCodeContentView removeFromSuperview];
    [_barCodeSizeLabel removeFromSuperview];
    [_barCodeSizeImageView removeFromSuperview];
    [[UIScreen mainScreen] setBrightness:_currentBrightness];
}

#pragma mark - 循环滚动
- (void)scroll {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + 10, 0) animated:NO];
    
    [UIView commitAnimations];
    
    if (_scrollView.contentOffset.x > _adContentLabel.frame.size.width) {
        _scrollView.contentOffset = CGPointMake(-_adContentLabel.frame.size.width, 0);
    }
}

#pragma mark - 加载条形码以及二维码
- (void)reloadQRCodeAndBarCode {
    [MBProgressHUD showHUDAddedTo:_rectView animated:YES];
    [_progressTimer invalidate];
    [self loadDataFromService];
}

- (void)loadQRCodeAndBarCode {
    // 异步加载
    [MBProgressHUD showHUDAddedTo:_rectView animated:YES];
    __weak XSVirtualMemberCardViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时操作
        [weakSelf loadDataFromService];
        
        // 切换到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

#pragma mark -- 加载编码
- (void)loadDataFromService {
    
    if (self.GetCodeBlock != nil) {
        self.GetCodeBlock();
    }
    
}

- (void)loadDataFromService1:(NSNotification *)nofi{
    
    NSDictionary * dic = nofi.userInfo;
    
    if ([dic[@"state"] isEqualToString:@"0"]) {
        [MBProgressHUD hideHUDForView:_rectView animated:true];
    }else{
        self.jsonDict = @{@"Data":@{@"Code":dic[@"code"],@"Time":@"60"}};
        
        self.code = [NSString stringWithFormat:@"%@",[[self.jsonDict objectForKey:@"Data"] objectForKey:@"Code"]];
        self.barCodeLabel.text = [self formatCode:self.code];
        NSInteger time = [[[self.jsonDict objectForKey:@"Data"] objectForKey:@"Time"] integerValue];
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressChanged) userInfo:nil repeats:YES];
        
        // 设置倒计时进度条
        self.progressView.progress = time / 60.0;
        
        // 生成条形码
        self.barCodeImageView.image = [self generateBarCode:self.code width:self.barCodeImageView.frame.size.width height:self.barCodeImageView.frame.size.height];
        if (self.barCodeContentView.frame.size.width != 0 && self.barCodeContentView.frame.size.height != 0) {
            NSLog(@"重新加载条形码");
            self.barCodeSizeImageView.image = [UIImage imageWithCIImage:[self.barCodeImageView.image CIImage] scale:1.0 orientation:UIImageOrientationRight];
            self.barCodeSizeLabel.text = [self formatCode:self.code];
        }
        
        // 生成二维码
        self.qrCodeImageView.image = [self generateQRCode:self.code width:self.qrCodeImageView.frame.size.width height:self.qrCodeImageView.frame.size.height];
        if (self.qrCodeContentView.frame.size.width != 0 && self.qrCodeContentView.frame.size.height != 0) {
            NSLog(@"重新加载二维码");
            self.qrCodeSizeImageView.image = [UIImage imageWithCIImage:[self.qrCodeImageView.image CIImage]];
        }
        
        // 添加放大事件
        [self.qrCodeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQRCodeBigger)]];
        [self.barCodeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBarCodeBigger)]];
        
        [MBProgressHUD hideHUDForView:_rectView animated:YES];
    }
    
}

#pragma mark -- 编码是否被扫描
- (void)loadScanDataFromService
{
    
    if (self.code != nil) {
        
        if (![_oldCode isEqualToString:self.code]) {
            _isShow = NO;
        }
        
        _oldCode = self.code;
        
        if (self.LoadScanDataFromServiceBlock != nil) {
            self.LoadScanDataFromServiceBlock(self.code);
        }
    }
    
}

- (void)loadScanDataFromService1:(NSNotification *)nofi{
    
    NSDictionary * dic = nofi.userInfo;
    
    if ([dic[@"state"] isEqualToString:@"1"] && [dic[@"code"] isEqualToString:_oldCode] && _isShow == NO) {
        _isShow = YES;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"付款码已被使用";
        hud.minSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 44);
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:1.f];
        
    }else{
        if (_timer) {
            [_timer invalidate];
        }
    }
}

#pragma mark - 格式化code
// 每隔4个字符空两格
- (NSString *)formatCode:(NSString *)code {
    
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3) {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++) {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];

    if ([temp length]>length) {
        temp = [temp substringToIndex:length];
    }
    
    return temp;
}

#pragma mark - 改变进度条进度
- (void)progressChanged {
    
    CGFloat step = 1.0 / 60.0;
    
    [_progressView setProgress:_progressView.progress - step animated:YES];
    
    if (_progressView.progress <= 0.0) {
        [_progressTimer invalidate];
        [self reloadQRCodeAndBarCode];
    }
    
}

#pragma mark - 生成条形码以及二维码

// 参考文档
// https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html

- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [_code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    // 生成二维码图片
    CIImage *barcodeImage;
    NSData *data = [_code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

- (void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
    [_scrollTimer invalidate];
    [_progressTimer invalidate];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RoloadWalletCodeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoadScanDataFromServiceNotification" object:nil];
}

@end
