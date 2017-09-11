//
//  WWCircleView.h
//  WWCircleView
//
//  Created by Carbon on 2017/9/8.
//  Copyright © 2017年 Carbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWCircleView;
@protocol WWCircleViewDelegate <NSObject>
- (void)ww_circleView:(WWCircleView *)circleView didSelectedWithIndex:(NSInteger)index;
@end

@interface WWCircleView : UIView
@property (nonatomic ,weak) id<WWCircleViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame circleCenter:(CGPoint)circleCenter contentsArray:(NSArray<UIView *> *)contentsArray;
@end
