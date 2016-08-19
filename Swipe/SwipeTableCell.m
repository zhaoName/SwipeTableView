//
//  SwipeTableCell.m
//  SwipeTableView
//
//  Created by zhao on 16/8/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "SwipeTableCell.h"

#define CELL_WIDTH self.bounds.size.width
#define CELL_HEIGHT self.bounds.size.height

@interface SwipeTableCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView; /**< 当前cell所在的tableView*/
@property (nonatomic, strong) UIImageView *swipeImageView; /**< 显示移动后的cell上的内容*/
@property (nonatomic, strong) UIView *rightSwipeView; /**< 右滑动展示的view*/
@property (nonatomic, strong) UIView *leftSwipeView; /**< 左滑展示的View*/

@property (nonatomic, assign) SwipeTableCellStyle swipeStyle; /**< 滑动样式 默认右滑*/
@property (nonatomic, strong) NSArray<SwipeButton *> *leftSwipeButtons; /**< 左滑buttons*/
@property (nonatomic, strong) NSArray<SwipeButton *> *rightSwipeButtons; /**< 右滑buttons*/

@property (nonatomic, assign) CGFloat swipeOffset; /**< 滑动偏移量*/
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture; /**< 滑动手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture; /**< 点击手势*/


@end

@implementation SwipeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initDatas];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if([super initWithCoder:aDecoder])
    {
        [self initDatas];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initDatas];
}

/**
 *  初始化数据
 */
- (void)initDatas
{
    self.swipeStyle = SwipeTableCellStyleRightToLeft; //默认右滑
    self.swipeOffset = 0.0;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];
}

#pragma mark -- 处理滑动手势
/**
 *  处理滑动手势 上左x<0、y<0  下右x>0、y>0
 */
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)pan
{
    CGPoint panPoint = [pan translationInView:self];
    NSLog(@"%f %f", panPoint.x, panPoint.y);
    
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        [self createSwipeImageViewIfNeed];
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        
    }
    else if(pan.state == UIGestureRecognizerStateEnded)
    {
        
    }
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == self.panGesture)
    {
        if(self.editing)  return NO;
        //使UITableView可以滚动 解决滑动tableView和滑动cell冲突额问题
        CGPoint panPoint = [self.panGesture translationInView:self];
        if(fabs(panPoint.x) < fabs(panPoint.y))
        {
            return NO;
        }
    }
    else if(gestureRecognizer == self.tapGesture)
    {
        //解决和didSelect冲突问题
        CGPoint tapPoint = [self.tapGesture locationInView:self.swipeImageView];
        return CGRectContainsPoint(self.swipeImageView.frame, tapPoint);
    }
    return YES;
}

/**
 *  创建用于显示滑动过后cell的SwipeImageView, 并添加滑动按钮
 */
- (void)createSwipeImageViewIfNeed
{
    [self getSwipeTableViewCellStyle];
    [self getSwipeButtons];
    
    [self.contentView addSubview:self.swipeImageView];
    //self.swipeImageView.hidden = YES;
    
    CGFloat rightButtonWidth = 0.0, leftButtonWidth = 0.0, offset = 0.0;
    //获取右滑按钮的总宽度
    for(SwipeButton *btn in self.rightSwipeButtons)
    {
        rightButtonWidth += btn.frame.size.width;
    }
    //获取左按钮的总宽度
    for(SwipeButton *btn in self.leftSwipeButtons)
    {
        leftButtonWidth += btn.frame.size.width;
    }
    
    if(self.rightSwipeButtons.count && self.rightSwipeView)
    {
        NSArray *array = [NSArray array];
        [self.swipeImageView addSubview:self.rightSwipeView];
        //右滑按钮取反序， 即数组的第一个元素放在最右边
        array = [[self.rightSwipeButtons reverseObjectEnumerator] allObjects];
        for(SwipeButton *button in array)
        {
            button.frame = CGRectMake(offset, 0, button.frame.size.width, CELL_HEIGHT);
            offset += button.frame.size.width;
            [button addTarget:self action:@selector(touchSwipeButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightSwipeView addSubview:button];
        }
        //改变rightSwipeView的frame 使其显示在cell的最右端
        self.rightSwipeView.frame = CGRectMake(CELL_WIDTH, 0, offset, CELL_HEIGHT);
        offset = 0.0;
    }
    if(self.leftSwipeButtons.count && self.leftSwipeView)
    {
        [self.swipeImageView addSubview:self.leftSwipeView];
        
        for(SwipeButton *button in self.leftSwipeButtons)
        {
            button.frame = CGRectMake(offset, 0, button.frame.size.width, CELL_HEIGHT);
            offset += button.frame.size.width;
            [button addTarget:self action:@selector(touchSwipeButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.leftSwipeView addSubview:button];
        }
        //改变leftSwipeView的frame 使其显示在cell的最左端
        self.leftSwipeView.frame = CGRectMake(-offset, 0, offset, CELL_HEIGHT);
        offset = 0.0;
    }
}

/**
 *  点击滑动按钮的响应事件
 */
- (void)touchSwipeButton:(SwipeButton *)btn
{
    btn.touchBlock();
}

#pragma mark -- 获取滑动按钮、滑动按钮的样式
/**
 *  获取滑动button的样式
 */
- (void)getSwipeTableViewCellStyle
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if([self.swipeDelegate respondsToSelector:@selector(tableView: styleOfSwipeButtonForRowAtIndexPath:)])
    {
        self.swipeStyle = [self.swipeDelegate tableView:self.tableView styleOfSwipeButtonForRowAtIndexPath:indexPath];
    }
}

/**
 *  获取滑动button
 */
- (void)getSwipeButtons
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if(self.swipeStyle == SwipeTableCellStyleRightToLeft)
    {
        if([self.swipeDelegate respondsToSelector:@selector(tableView: rightSwipeButtonsAtIndexPath:)])
        {
            self.rightSwipeButtons = [[self.swipeDelegate tableView:self.tableView rightSwipeButtonsAtIndexPath:indexPath] mutableCopy];
        }
    }
    else if(self.swipeStyle == SwipeTableCellStyleLeftToRight)
    {
        if([self.swipeDelegate respondsToSelector:@selector(tableView : leftSwipeButtonsAtIndexPath:)])
        {
            self.leftSwipeButtons = [self.swipeDelegate tableView:self.tableView leftSwipeButtonsAtIndexPath:indexPath];
        }
    }
    else if(self.swipeStyle == SwipeTableCellStyleBoth)
    {
        if([self.swipeDelegate respondsToSelector:@selector(tableView: rightSwipeButtonsAtIndexPath:)])
        {
            self.rightSwipeButtons = [self.swipeDelegate tableView:self.tableView rightSwipeButtonsAtIndexPath:indexPath];
        }
        
        if([self.swipeDelegate respondsToSelector:@selector(tableView : leftSwipeButtonsAtIndexPath:)])
        {
            self.leftSwipeButtons = [self.swipeDelegate tableView:self.tableView leftSwipeButtonsAtIndexPath:indexPath];
        }
    }
}

#pragma mark -- 私有方法

/**
 *  截取平移过后的cell上的内容 以图片的形式显示出来
 */
- (UIImage *)fecthTranslatedCellInfo:(UIView *)cell
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -- getter或setter

/**重谢tableView的getter方法 获取cell所在的tableView*/
- (UITableView *)tableView
{
    if(_tableView){
        return _tableView;
    }
    //获取当前cell所在的父tableView
    UIView *view = self.superview;
    while (view != nil)
    {
        if([view isKindOfClass:[UITableView class]])
        {
            _tableView = (UITableView *)view;
        }
        view = view.superview;
    }
    return _tableView;
}

/** 重写swipeOffset的setter方法 监测滑动手势*/
- (void)setSwipeOffset:(CGFloat)swipeOffset
{
    CGFloat sign = swipeOffset > 0 ? 1 : -1;
    UIView *swipeView = swipeOffset < 0 ? self.rightSwipeView : self.leftSwipeView;
    
    _swipeOffset = swipeOffset;
    
    if(!swipeView || swipeOffset == 0)
    {
        return;
    }
    else
    {
        
    }
    
    NSUInteger offset = fabs(swipeOffset);
//    self.swipeImageView.transform = CGAffineTransformMakeTranslation(-offset, 0);
//    self.swipeImageView.image = [self fecthTranslatedCellInfo:self];
//    self.rightSwipeView.frame = CGRectMake(CELL_WIDTH-swipeViewWidth, 0, swipeViewWidth, CELL_HEIGHT);
}

#pragma mark -- 懒加载

- (UIImageView *)swipeImageView
{
    if(!_swipeImageView)
    {
        _swipeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
    }
    return _swipeImageView;
}

- (UIView *)rightSwipeView
{
    if(!_rightSwipeView)
    {
        _rightSwipeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        _rightSwipeView.backgroundColor = [UIColor clearColor];
    }
    return _rightSwipeView;
}

- (UIView *)leftSwipeView
{
    if(!_leftSwipeView)
    {
        _leftSwipeView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftSwipeView.backgroundColor = [UIColor clearColor];
    }
    return _leftSwipeView;
}

- (NSArray<SwipeButton *> *)leftSwipeButtons
{
    if(!_leftSwipeButtons)
    {
        _leftSwipeButtons = [NSArray array];
    }
    return _leftSwipeButtons;
}

- (NSArray<SwipeButton *> *)rightSwipeButtons
{
    if(!_rightSwipeButtons)
    {
        _rightSwipeButtons = [NSArray array];
    }
    return _rightSwipeButtons;
}

@end
