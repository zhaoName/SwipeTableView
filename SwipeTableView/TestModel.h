//
//  TestModel.h
//  SwipeTableView
//
//  Created by zhao on 16/11/14.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "SwipeTableCell.h"

@interface TestModel : NSObject

@property (nonatomic, assign) SwipeTableCellStyle cellStyle;
@property (nonatomic, assign) SwipeViewTransfromMode transformMode;
@property (nonatomic, assign) BOOL isRefreshButton;
@property (nonatomic, strong) NSString *data;

@end
