//
//  SwipeTableCell.h
//  SwipeTableView
//
//  Created by zhao on 16/8/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeButton.h"

typedef NS_ENUM(NSUInteger, SwipeTableCellStyle)
{
    SwipeTableCellStyleRightToLeft = 0, /**< 右滑*/
    SwipeTableCellStyleLeftToRight , /**< 左滑*/
    SwipeTableCellStyleBoth, /**< 左滑、右滑都有*/
};

@protocol SwipeTableViewDelegate <NSObject>

@optional
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

@end




@class SwipeTableViewDelegate;
@interface SwipeTableCell : UITableViewCell

@property (nonatomic, weak) id<SwipeTableViewDelegate> swipeDelegate;


@end
