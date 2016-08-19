//
//  SwipeButton.m
//  SwipeTableView
//
//  Created by zhao on 16/8/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "SwipeButton.h"

@implementation SwipeButton

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title touchBlock:(TouchSwipeButtonBlock)block
{
    return [self createSwipeButtonWithTitle:title font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] touchBlock:block];
}

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor touchBlock:(TouchSwipeButtonBlock)block
{
    return [self createSwipeButtonWithTitle:title font:font textColor:textColor backgroundColor:[UIColor whiteColor] touchBlock:block];
}

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor touchBlock:(TouchSwipeButtonBlock)block
{
    return [self createSwipeButtonWithTitle:title font:font textColor:textColor backgroundColor:backgroundColor image:nil touchBlock:block];
}

+ (SwipeButton *)createSwipeButtonWithImage:(UIImage *)image touchBlock:(TouchSwipeButtonBlock)block
{
    return [self createSwipeButtonWithTitle:nil font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] backgroundColor:[UIColor redColor] image:image touchBlock:block];
}

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image touchBlock:(TouchSwipeButtonBlock)block
{
    SwipeButton *button = [self buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    [button setImage:image forState:UIControlStateNormal];
    button.touchBlock = block;
    
    return button;
}

@end
