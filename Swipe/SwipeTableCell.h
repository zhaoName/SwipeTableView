//
//  SwipeTableCell.h
//  SwipeTableView
//
//  Created by zhao on 16/8/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeButton.h"
#import "SwipeView.h"


typedef NS_ENUM(NSUInteger, SwipeTableCellStyle)
{
    SwipeTableCellStyleRightToLeft = 0, /**< 右滑*/
    SwipeTableCellStyleLeftToRight , /**< 左滑*/
    SwipeTableCellStyleBoth, /**< 左滑、右滑都有*/
};

@class SwipeTableCell;
@protocol SwipeTableViewCellDelegate <NSObject>

@required
/**
 *  设置cell的滑动按钮的样式 (左滑、右滑、左滑右滑都有)
 *
 *  @param indexPath cell的位置
 */
- (SwipeTableCellStyle)tableView:(UITableView *)tableView styleOfSwipeButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  左滑cell时显示的button
 *
 *  @param indexPath cell的位置
 */
- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView leftSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  右滑cell时显示的button
 *
 *  @param indexPath cell的位置
 */
- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView rightSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  当滑动手势结束后，点击cell是否隐藏swipeView，即cell自动回复到最初状态。默认YES
 */
- (BOOL)tableView:(UITableView *)tableView hiddenSwipeViewWhenTapCellAtIndexpath:(NSIndexPath *)indexPath;

/**
 *  点击按钮隐藏SwipeView 默认YES
 *
 *  @param cell 按钮所在的cell
 *
 *  @return 是否隐藏
 */
- (BOOL)hideSwipeViewWhenClickSwipeButtonAtCell:(SwipeTableCell *)cell;

/**
 * 设置swipeView的弹出样式
 */
- (SwipeViewTransfromMode)tableView:(UITableView *)tableView swipeViewTransformModeAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 设置swipeButton 距上左下右的间距
 *
 * @warn 值要>0 否则可能导致显示不全
 */
- (UIEdgeInsets)tableView:(UITableView *)tableView swipeButtonEdgeAtIndexPath:(NSIndexPath *)indexPath;

@end


@class SwipeTableViewDelegate;
@interface SwipeTableCell : UITableViewCell

@property (nonatomic, weak) id<SwipeTableViewCellDelegate> swipeDelegate;
@property (nonatomic, strong) UIColor *swipeOverlayViewBackgroundColor; /**< swipeButton下的背景色 默认透明色*/
@property (nonatomic, assign) BOOL isAllowMultipleSwipe; /**< 是否允许多个cell同时滑动 默认NO*/
@property (nonatomic, assign) CGFloat swipeThreshold;/**< 当结束滑动手势时，显示或隐藏SwipeView的临界值 范围:0-1，默认0.5*/

@property (nonatomic, assign, readonly) BOOL hideSwipeViewWhenScrollTableView; /**< 滚动TableView时是否隐藏swipeView 默认YES*/
@property (nonatomic, assign) BOOL hideSwipeViewWhenClickSwipeButton; /**< 点击按钮隐藏SwipeView 默认YES*/


/**
 *  隐藏滑动按钮 即将cell恢复原状
 *
 *  @param isAnimation 是否隐藏
 */
- (void)hiddenSwipeAnimationAtCell:(BOOL)isAnimation;

/**
 *  更改滑动按钮的内容 如置顶变成取消置顶
 */
- (void)refreshButtoncontent;

@end
