//
//  WWCircleView.m
//  WWCircleView
//
//  Created by Carbon on 2017/9/8.
//  Copyright © 2017年 Carbon. All rights reserved.
//

#import "WWCircleView.h"
#import <objc/runtime.h>

#define ww_ViewWidth   self.frame.size.width
#define ww_ViewHeight  self.frame.size.height
@interface UIView (WWCircleContentView)

@property (nonatomic ,assign) CGFloat   ww_currentRadian_Y;
@property (nonatomic ,assign) CGFloat   ww_radian_Y;
@property (nonatomic ,assign) CGFloat   ww_currentRadian_X;
@property (nonatomic ,assign) CGFloat   ww_radian_X;
@property (nonatomic ,assign) NSInteger ww_index;

@end

@implementation UIView (WWCircleContentView)

static char *ww_CurRad_Y_Key = "ww_CurRad_Y_Key";
static char *ww_Rad_Y_Key    = "ww_Rad_Y_Key";
static char *ww_CurRad_X_Key = "ww_CurRad_X_Key";
static char *ww_Rad_X_Key    = "ww_Rad_X_Key";
static char *ww_Index_Key    = "ww_Index_Key";

- (void)setWw_currentRadian_Y:(CGFloat)ww_currentRadian_Y {
    objc_setAssociatedObject(self, ww_CurRad_Y_Key, @(ww_currentRadian_Y), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ww_currentRadian_Y {
    return [objc_getAssociatedObject(self, ww_CurRad_Y_Key) doubleValue];
}

- (void)setWw_radian_Y:(CGFloat)ww_radian_Y {
    objc_setAssociatedObject(self, ww_Rad_Y_Key, @(ww_radian_Y), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ww_radian_Y {
    return [objc_getAssociatedObject(self, ww_Rad_Y_Key) doubleValue];
}

- (void)setWw_currentRadian_X:(CGFloat)ww_currentRadian_X {
    objc_setAssociatedObject(self, ww_CurRad_X_Key, @(ww_currentRadian_X), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ww_currentRadian_X {
    return [objc_getAssociatedObject(self, ww_CurRad_X_Key) doubleValue];
}

- (void)setWw_radian_X:(CGFloat)ww_radian_X {
    objc_setAssociatedObject(self, ww_Rad_X_Key, @(ww_radian_X), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ww_radian_X {
    return [objc_getAssociatedObject(self, ww_Rad_X_Key) doubleValue];
}

- (void)setWw_index:(NSInteger)ww_index {
    objc_setAssociatedObject(self, ww_Index_Key, @(ww_index), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)ww_index {
    return [objc_getAssociatedObject(self, ww_Index_Key) integerValue];
}

@end

@interface WWCircleView ()

@property (nonatomic ,copy)   NSArray<UIView *>  *contentsArray;
@property (nonatomic ,assign) CGPoint            circleCenter;
@property (nonatomic ,assign) CGFloat            radius;
@property (nonatomic ,assign) CGFloat            average_radian;
@property (nonatomic ,assign) CGPoint            dragPoint;
@property (nonatomic ,assign) NSInteger          step;

@end

@implementation WWCircleView

- (instancetype)initWithFrame:(CGRect)frame circleCenter:(CGPoint)circleCenter contentsArray:(NSArray<UIView *> *)contentsArray{
    if (self = [super initWithFrame:frame]) {
        self.circleCenter = circleCenter;
        self.contentsArray = contentsArray;
        [self ww_setupUI];
        [self ww_addGesture];
    }
    return self;
}

- (void)ww_setupUI {
    CGFloat radian_Y;
    self.average_radian = (2*M_PI)/self.contentsArray.count;
    self.radius = MIN(ww_ViewWidth, ww_ViewHeight)/2.0;
    for (NSInteger i = 0; i < self.contentsArray.count; i++) {
        radian_Y = [self ww_getNomalRadianByRadian:i*self.average_radian];
        CGPoint center = [self ww_getPointByRadian:radian_Y circleCenter:self.circleCenter circleRadius:self.radius];
        UIView *v = [self.contentsArray objectAtIndex:i];
        v.center = center;
        v.ww_currentRadian_Y = radian_Y;
        v.ww_radian_Y = radian_Y;
        v.ww_currentRadian_X = [self ww_getX_RadianByY_Radian:radian_Y];
        v.ww_radian_X = [self ww_getX_RadianByY_Radian:radian_Y];
        [self addSubview:v];
        UIButton *b = [[UIButton alloc] init];
        b.ww_index = i;
        b.frame = v.bounds;
        [b addTarget:self action:@selector(ww_buttonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:b];
    }
    
    
}

- (CGFloat)ww_getNomalRadianByRadian:(CGFloat)radian {
    if(radian > 2*M_PI)
        return (radian - floorf(radian/(2.0f*M_PI))*2.0f*M_PI);
    if(radian < 0.0f)
        return (2.0f*M_PI+radian-ceilf(radian/(2.0f*M_PI))*2.0f*M_PI);
    return radian;
}

- (CGPoint)ww_getPointByRadian:(CGFloat)radian circleCenter:(CGPoint)center circleRadius:(CGFloat)radius {
    CGFloat c_x = sinf(radian)*radius+center.x;
    CGFloat c_y = cosf(radian)*radius+center.y;
    return CGPointMake(c_x, c_y);
}

- (CGFloat)ww_getX_RadianByY_Radian:(CGFloat)radian {
    CGFloat x_Radian = 2.0f*M_PI-radian+M_PI_2;
    return x_Radian < 0.0f? (-x_Radian) : x_Radian;
}

- (void)ww_addGesture {
    UISwipeGestureRecognizer *swipeRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ww_handleSwipe:)];
    swipeRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeRecognizerUp];
    
    UISwipeGestureRecognizer *swipeRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ww_handleSwipe:)];
    swipeRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeRecognizerDown];
}

#pragma mark -- private
- (void)ww_buttonHandle:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ww_circleView:didSelectedWithIndex:)]) {
        [self.delegate ww_circleView:self didSelectedWithIndex:sender.ww_index];
    }
}

- (void)ww_handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [self ww_swipeDirectionUp];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [self ww_swipeDirectionDown];
    } else {}
}

- (void)ww_swipeDirectionUp {
    UIView *vTemp = [self.contentsArray objectAtIndex:0];
    CGPoint center = vTemp.center;
    CGFloat currentRadian_Y = vTemp.ww_currentRadian_Y;
    CGFloat currentRadian_X = vTemp.ww_currentRadian_X;
    for (NSInteger i = 0; i < self.contentsArray.count; i++) {
        UIView *vPre = [self.contentsArray objectAtIndex:i];
        if (i < self.contentsArray.count-1) {
            UIView *vNext = [self.contentsArray objectAtIndex:i+1];
            [UIView animateWithDuration:0.5 animations:^{
                vPre.center = vNext.center;
                vPre.ww_currentRadian_X = vNext.ww_radian_X;
                vPre.ww_currentRadian_Y = vNext.ww_radian_Y;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                vPre.center = center;
                vPre.ww_currentRadian_X = currentRadian_X;
                vPre.ww_currentRadian_Y = currentRadian_Y;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)ww_swipeDirectionDown {
    UIView *vTemp = [self.contentsArray objectAtIndex:self.contentsArray.count-1];
    CGPoint center = vTemp.center;
    CGFloat currentRadian_Y = vTemp.ww_currentRadian_Y;
    CGFloat currentRadian_X = vTemp.ww_currentRadian_X;
    for (NSInteger i = (self.contentsArray.count-1); i > -1; i--) {
        UIView *vPre = [self.contentsArray objectAtIndex:i];
        if (i > 0) {
            UIView *vNext = [self.contentsArray objectAtIndex:i-1];
            [UIView animateWithDuration:0.5 animations:^{
                vPre.center = vNext.center;
                vPre.ww_currentRadian_X = vNext.ww_radian_X;
                vPre.ww_currentRadian_Y = vNext.ww_radian_Y;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                vPre.center = center;
                vPre.ww_currentRadian_X = currentRadian_X;
                vPre.ww_currentRadian_Y = currentRadian_Y;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

@end
