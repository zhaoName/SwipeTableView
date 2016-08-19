//
//  SwipeButton.h
//  SwipeTableView
//
//  Created by zhao on 16/8/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchSwipeButtonBlock)(void);

@interface SwipeButton : UIButton

@property (nonatomic, strong) TouchSwipeButtonBlock touchBlock;

/**
 *  创建左滑或右滑时的button
 *
 *  @param title button的标题 可为空
 *  @param font  button的字体大小 默认为15
 *  @param textColor button的字体颜色 默认黑色
 *  @param backgroundColor  button的背景颜色 默认白色
 *  @param image button的背景图片 可为空
 */
+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title touchBlock:(TouchSwipeButtonBlock)block;

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor touchBlock:(TouchSwipeButtonBlock)block;

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor touchBlock:(TouchSwipeButtonBlock)block;


+ (SwipeButton *)createSwipeButtonWithImage:(UIImage *)image touchBlock:(TouchSwipeButtonBlock)block;

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image touchBlock:(TouchSwipeButtonBlock)block;


@end
