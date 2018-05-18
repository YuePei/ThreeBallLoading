
//
//  ViewController.m
//  ThreeBallAnimation
//
//  Created by Peyton on 2018/5/18.
//  Copyright © 2018年 Peyton. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>
//view1
@property (nonatomic, strong)UIView *view1;
//view2
@property (nonatomic, strong)UIView *view2;
//view3
@property (nonatomic, strong)UIView *view3;

@end

@implementation ViewController
static const float animationDuration = 1.6;
static bool animationFinished;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self view1];
    [self view2];
    [self view3];
    
}

- (void)startAnimation {
    //1.第三个小球的动画
    //阶段1: 画个半圆转到第二个球右侧
    CGFloat r = CGRectGetWidth(self.view1.frame) / 2.0;
    CGFloat bigR = 1.5 * r;
    CGFloat bigR2 = (self.view2.center.x + 2 * bigR - self.view1.center.x) / 2.0;
    CGPoint middlePoint = CGPointMake( bigR2 + self.view1.center.x,self.view1.frame.origin.y + CGRectGetHeight(self.view1.frame) / 2.0);
    CGFloat radius = bigR2 ;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:middlePoint radius:radius startAngle:M_PI endAngle:0 clockwise:NO];
    
    //阶段2: 绕第二个小球旋转半轴
    CGPoint middlePoint1 = self.view2.center;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:middlePoint1 radius:bigR * 2 startAngle:0 endAngle:M_PI clockwise:NO];
    [path appendPath:path1];
    
    //阶段3: 回到初始位置
    [path addLineToPoint:self.view1.center];
    
    CAKeyframeAnimation *kf = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    kf.delegate = self;
    kf.path = path.CGPath;
    kf.duration = animationDuration;
    kf.removedOnCompletion = YES;
    kf.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.view1.layer addAnimation:kf forKey:@"test"];
    
    
    //2.第三个小球的动画
    //只是中心点发生变化, 半径都没有变化
    CGPoint middlePoint2 = CGPointMake( bigR2 + self.view2.center.x - 2 * bigR,self.view2.frame.origin.y + CGRectGetHeight(self.view2.frame) / 2.0);
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:middlePoint2 radius:radius startAngle:0 endAngle:M_PI clockwise:NO];
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:self.view2.center radius:2 * bigR startAngle:M_PI endAngle:0 clockwise:NO];
    [path2 appendPath:path3];
    [path2 addLineToPoint:self.view3.center];
    CAKeyframeAnimation *kf2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    kf2.duration = 1.6;
    kf2.path = path2.CGPath;
    kf2.removedOnCompletion = YES;
    kf2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    kf2.delegate = self;
    [self.view3.layer addAnimation:kf2 forKey:@"animation2"];
    animationFinished = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startAnimation];
    animationFinished = NO;
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    float duration = animationDuration / 2 - 0.3;
    [UIView animateWithDuration:duration delay:0.3 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view1.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.view2.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.view3.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.view1.transform = CGAffineTransformIdentity;
            self.view2.transform = CGAffineTransformIdentity;
            self.view3.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self startAnimation];
}

- (UIView *)view1 {
    if (!_view1) {
        _view1 = [[UIView alloc]initWithFrame:CGRectMake(110, 100, 20, 20)];
        [self.view addSubview:_view1];
        _view1.layer.cornerRadius = 10;
        _view1.layer.masksToBounds = YES;
        _view1.backgroundColor = [UIColor redColor];
    }
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        _view2 = [[UIView alloc]initWithFrame:CGRectMake(170, 100, 20, 20)];
        [self.view addSubview:_view2];
        _view2.layer.cornerRadius = 10;
        _view2.layer.masksToBounds = YES;
        _view2.backgroundColor = [UIColor grayColor];
    }
    return _view2;
}

- (UIView *)view3 {
    if (!_view3) {
        _view3 = [[UIView alloc]initWithFrame:CGRectMake(230, 100, 20, 20)];
        [self.view addSubview:_view3];
        _view3.backgroundColor = [UIColor blueColor];
        _view3.layer.cornerRadius = 10;
        _view3.layer.masksToBounds = YES;
    }
    return _view3;
}
@end
