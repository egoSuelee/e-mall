//
//  MJRefreshStateHeaderMoreAction.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshStateHeaderMoreAction.h"

@interface MJRefreshStateHeaderMoreAction()
{
    /** 显示刷新状态的label */
    __weak UILabel *_stateLabel;
}
@property (weak, nonatomic) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation MJRefreshStateHeaderMoreAction
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark key的处理
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:MJRefreshHeaderIdleText forState:MJRefreshStateIdle];
    [self setTitle:MJRefreshHeaderPullingText forState:MJRefreshStatePulling];
    [self setTitle:MJRefreshHeaderRefreshingText forState:MJRefreshStateRefreshing];
    [self setTitle:MJRefreshHeaderRefreshingMoreActionText forState:MJRefreshStatePullingTopMoreAction];
    [self setTitle:MJRefreshHeaderIdleText forState:MJRefreshStateTopMoreAction];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden){
        return;
    }else{
        self.gifView.frame = self.bounds;
        self.gifView.contentMode = UIViewContentModeScaleToFill;
        
        // 状态
        self.stateLabel.mj_x = 0;
        self.stateLabel.mj_y = self.mj_h - MJRefreshHeaderHeight;
        self.stateLabel.mj_w = self.mj_w;
        self.stateLabel.mj_h = MJRefreshHeaderHeight;
        
        [self bringSubviewToFront:self.stateLabel];
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 根据状态做事情
    NSMutableArray *images = [NSMutableArray array];
    
    if (self.stateImages[@(state)] == nil) {
        
        UIImage *image = [UIImage imageNamed:MJRefreshSrcName(@"小鸟.png")];
        /* 根据图片设置控件的高度 */
        if (image.size.height > self.mj_h) {
            self.mj_h = image.size.height;
        }
        
        [images addObject:image];
    }else{
        images = [self.stateImages[@(state)] mutableCopy];
    };
    
    [self.gifView stopAnimating];
    if (images.count == 1) { // 单张图片
        self.gifView.image = [images lastObject];
    } else { // 多张图片
        self.gifView.animationImages = images;
        self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
        [self.gifView startAnimating];
    }

}
@end
