//
//  SwipeTableCell.h
//  SwipeTableView
//
//  Created by zhao on 16/8/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeButton.h"
#import "SwipeAnimation.h"


typedef NS_ENUM(NSUInteger, SwipeTableCellStyle)
{
    SwipeTableCellStyleRightToLeft = 0, /**< 右滑*/
    SwipeTableCellStyleLeftToRight , /**< 左滑*/
    SwipeTableCellStyleBoth, /**< 左滑、右滑都有*/
};

@protocol SwipeTableViewDelegate <NSObject>

@required
/**
 *  设置cell的滑动按钮的样式
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

@end




@class SwipeTableViewDelegate;
@interface SwipeTableCell : UITableViewCell

@property (nonatomic, weak) id<SwipeTableViewDelegate> swipeDelegate;
@property (nonatomic, assign) BOOL isAllowMultipleSwipe; /**< 是否允许多个cell同时滑动*/
@property (nonatomic, assign) CGFloat swipeThreshold;/**< 当结束滑动手势时，显示或隐藏按钮的临界值 范围:0-1，默认0.5*/

@property (nonatomic, assign) SwipeViewTransfromMode transformModel; /**< swipeView的弹出效果*/

@end
