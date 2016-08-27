//
//  SwipeAnimation.h
//  SwipeTableView
//
//  Created by zhao on 16/8/27.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MGSwipeEasingFunction) {
    MGSwipeEasingFunctionLinear = 0,
    MGSwipeEasingFunctionQuadIn,
    MGSwipeEasingFunctionQuadOut,
    MGSwipeEasingFunctionQuadInOut,
    MGSwipeEasingFunctionCubicIn,
    MGSwipeEasingFunctionCubicOut,
    MGSwipeEasingFunctionCubicInOut,
    MGSwipeEasingFunctionBounceIn,
    MGSwipeEasingFunctionBounceOut,
    MGSwipeEasingFunctionBounceInOut
};

typedef NS_ENUM(NSUInteger, SwipeViewTransfromMode)
{
    SwipeViewTransfromModeDefault = 0, /**< 默认效果，拖拽*/
    SwipeViewTransfromModeBorder, /**< 渐出*/
    SwipeViewTransfromMode3D, /**< 3D*/
};

@interface SwipeAnimation : NSObject

@property (nonatomic, assign) CGFloat from;
@property (nonatomic, assign) CGFloat to;
@property (nonatomic, assign) CFTimeInterval start;
@property (nonatomic, assign) CGFloat duration; /**<动画持续时间 默认0.3*/
@property (nonatomic, assign) MGSwipeEasingFunction easingFunction; /**< 手势动画执行节奏*/
@property (nonatomic, assign) SwipeViewTransfromMode mode;/**< swipeView的弹出效果*/

/**
 *  滑动手势滑动的距离超过swipeView的一半时，会自动显示或隐藏swipeView
 */
- (CGFloat)value:(CGFloat)elapsed duration:(CGFloat)duration from:(CGFloat)from to:(CGFloat)to;



- (void)swipeView:(UIView *)swipeView swipeButtons:(NSArray *)buttons fromRight:(BOOL)fromRight effect:(CGFloat)t cellHeight:(CGFloat)cellHeight;

@end
