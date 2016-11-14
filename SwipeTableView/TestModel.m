//
//  TestModel.m
//  SwipeTableView
//
//  Created by zhao on 16/11/14.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

@synthesize transformMode = _transformMode;
@synthesize cellStyle = _cellStyle;
@synthesize isRefreshButton = _isRefreshButton;


- (void)setTransformMode:(SwipeViewTransfromMode)transformMode
{
    _transformMode = transformMode;
}

- (SwipeViewTransfromMode)transformMode
{
    return _transformMode;
}


- (void)setCellStyle:(SwipeTableCellStyle)cellStyle
{
    _cellStyle = cellStyle;
}

- (SwipeTableCellStyle)cellStyle
{
    return _cellStyle;
}


- (void)setIsRefreshButton:(BOOL)isRefreshButton
{
    _isRefreshButton = isRefreshButton;
}

- (BOOL)isRefreshButton
{
    return _isRefreshButton;
}

@end
