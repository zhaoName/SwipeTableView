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
@property (nonatomic, strong) UIView *swipeOverlayView; /**< 滑动时覆盖在cell上*/
@property (nonatomic, strong) UIImageView *swipeImageView; /**< 显示移动后的cell上的内容*/
@property (nonatomic, strong) UIView *rightSwipeView; /**< 右滑展示的view*/
@property (nonatomic, strong) UIView *leftSwipeView; /**< 左滑展示的View*/

@property (nonatomic, assign) SwipeTableCellStyle swipeStyle; /**< 滑动样式 默认右滑*/
@property (nonatomic, strong) NSArray<SwipeButton *> *leftSwipeButtons; /**< 左滑buttons*/
@property (nonatomic, strong) NSArray<SwipeButton *> *rightSwipeButtons; /**< 右滑buttons*/
@property (nonatomic, strong) NSMutableSet *perviusHiddenViewSet;/**< 已经隐藏的view*/

@property (nonatomic, assign) CGFloat swipeOffset; /**< 滑动偏移量*/
@property (nonatomic, assign) CGFloat targetOffset; /**< 最终目标偏移量*/
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture; /**< 滑动手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture; /**< 点击手势*/

@property (nonatomic, assign) CGPoint panStartPoint; /**<滑动手势开始点击的坐标*/
@property (nonatomic, assign) CGFloat panStartOffset; /**<滑动手势的偏移量*/
@property (nonatomic, assign) BOOL isShowSwipeOverlayView; /**< 保证显示、隐藏swipeImageView方法只走一次*/

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
    self.targetOffset = 0.0;
    self.isAllowMultipleSwipe = NO;
    self.isShowSwipeOverlayView = NO;
    
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
    CGPoint currentPanPoint = [pan translationInView:self];
    
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        self.panStartPoint = currentPanPoint;
        self.panStartOffset = self.swipeOffset;
        
        [self createSwipeOverlayViewIfNeed];
        //不允许多个cell同时能滑动，则移除上一个cell的滑动手势
        if(!_isAllowMultipleSwipe)
        {
            for(SwipeTableCell * cell in self.tableView.visibleCells)
            {
                if(cell != self) [cell cancelPanGesture];
            }
        }
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offset = self.panStartOffset + currentPanPoint.x - self.panStartPoint.x;
        //重新swipeOffset的setter方法，监测滑动偏移量
        self.swipeOffset = [self filterSwipeOffset:offset];
    }
    else if(pan.state == UIGestureRecognizerStateEnded)
    {
//        CGFloat velocity = [self.panGesture velocityInView:self].x;
//        CGFloat inertiaThreshold = 100; //每秒走过多少像素
//        
//        if(velocity > inertiaThreshold)
//        {
//            self.targetOffset = self.swipeOffset < 0 ? 0 : (self.leftSwipeView ? self.leftSwipeView.frame.size.width : self.targetOffset);
//        }
//        else if(velocity < -inertiaThreshold)
//        {
//            self.targetOffset = self.swipeOffset > 0 ? 0 : (self.rightSwipeView ? -self.rightSwipeView.frame.size.width : self.targetOffset);
//        }
//        self.targetOffset = [self filterSwipeOffset:self.targetOffset];
//        NSLog(@"targetOffset:%f", self.targetOffset);
//        if(self.targetOffset == 0)
//        {
//            if(self.rightSwipeView){
//                self.rightSwipeView.transform = CGAffineTransformMakeTranslation(self.rightSwipeView.frame.size.width, 0);
//            }
//            if(self.leftSwipeView){
//                self.leftSwipeView.transform = CGAffineTransformMakeTranslation(self.swipeOffset, 0);
//            }
//            self.swipeImageView.transform = CGAffineTransformMakeTranslation(self.swipeOffset, 0);
//        }
//        else if (fabs(self.swipeOffset) > fabs(self.targetOffset))
//        {
//            
//        }
//        else
//        {
//            
//        }
    }
}

/**
 *  创建用于显示滑动过后cell内容的SwipeImageView, 并在其上添加滑动按钮
 */
- (void)createSwipeOverlayViewIfNeed
{
    [self getSwipeTableViewCellStyle];
    [self getSwipeButtons];
    
    if(!self.swipeOverlayView)
    {
        _swipeOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        _swipeOverlayView.backgroundColor = [UIColor clearColor];
        _swipeOverlayView.hidden = YES;
        
        _swipeImageView = [[UIImageView alloc] initWithFrame:self.swipeOverlayView.bounds];
        _swipeImageView.userInteractionEnabled = YES;
        
        [_swipeOverlayView addSubview:_swipeImageView];
        [self addSubview:self.swipeOverlayView];
    }
    
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

    if(self.rightSwipeButtons.count && !self.rightSwipeView)
    {
        _rightSwipeView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightSwipeView.backgroundColor = [UIColor clearColor];
        
        NSArray *array = [NSArray array];
        [self.swipeOverlayView addSubview:_rightSwipeView];
        //右滑按钮取反序， 即数组的第一个元素放在最右边
        array = [[self.rightSwipeButtons reverseObjectEnumerator] allObjects];
        for(SwipeButton *button in array)
        {
            button.frame = CGRectMake(offset, 0, MAX(button.frame.size.width, CELL_HEIGHT), CELL_HEIGHT);
            offset += button.frame.size.width;
            [button addTarget:self action:@selector(touchSwipeButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightSwipeView addSubview:button];
        }
        //改变rightSwipeView的frame 使其显示在swipeImageView的最右端
        self.rightSwipeView.frame = CGRectMake(self.swipeImageView.bounds.size.width, 0, offset, CELL_HEIGHT);
        offset = 0.0;
    }
    if(self.leftSwipeButtons.count && !self.leftSwipeView)
    {
        _leftSwipeView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftSwipeView.backgroundColor = [UIColor clearColor];
        [self.swipeOverlayView addSubview:_leftSwipeView];
        
        for(SwipeButton *button in self.leftSwipeButtons)
        {
            button.frame = CGRectMake(offset, 0, MAX(button.frame.size.width, CELL_HEIGHT), CELL_HEIGHT);
            offset += button.frame.size.width;
            [button addTarget:self action:@selector(touchSwipeButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.leftSwipeView addSubview:button];
        }
        //改变leftSwipeView的frame 使其显示在swipeImageView的最左端
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

/**
 * 判断滑动是否合法 并返回滑动距离
 */
- (CGFloat)filterSwipeOffset:(CGFloat)offset
{
    UIView *swipeView = offset > 0 ? self.leftSwipeView : self.rightSwipeView;
    if(!swipeView)
    {
        return 0.0;
    }
    else if(self.swipeStyle == SwipeTableCellStyleLeftToRight && offset < 0)
    {
        return 0.0;
    }
    else if(self.swipeStyle == SwipeTableCellStyleRightToLeft && offset > 0)
    {
        return 0.0;
    }
    return offset;
}

/**
 *  当滑动下一个cell时 取消上一个cell的滑动手势
 */
- (void)cancelPanGesture
{
    self.panGesture.enabled = NO;
    self.panGesture.enabled = YES;
    //将上一个cell恢复原状
    if(self.swipeOffset){
        [self hiddenSwipeViewAtCell];
    }
}

#pragma mark -- 处理点击手势

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    BOOL hidden = YES;
    if([self.swipeDelegate respondsToSelector:@selector(swipeCell:hiddenSwipeViewWhenTapCell:)])
    {
        //判断点击cell是否隐藏swipeView
        hidden = [self.swipeDelegate swipeCell:self hiddenSwipeViewWhenTapCell:[self.tapGesture locationInView:self]];
    }
    if(hidden)
    {
        [self hiddenSwipeViewAtCell];
    }
}

- (void)hiddenSwipeViewAtCell
{
    self.swipeOffset = 0.0;
}

#pragma mark -- UIGestureRecognizerDelegates

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == self.panGesture)
    {
        if(self.editing)  return NO;
        //使UITableView可以滚动 解决滑动tableView和滑动cell冲突额问题
        CGPoint panPoint = [self.panGesture translationInView:self];
        if(fabs(panPoint.x) < fabs(panPoint.y))  return NO;
    }
    else if(gestureRecognizer == self.tapGesture)
    {
        //解决和didSelect冲突问题
        CGPoint tapPoint = [self.tapGesture locationInView:self];
        //NSLog(@"%@,%@", NSStringFromCGRect(self.swipeOverlayView.frame), NSStringFromCGPoint(tapPoint));
        return CGRectContainsPoint(self.swipeImageView.frame, tapPoint);
    }
    return YES;
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

/**< 删除所有子视图*/
- (void)removeAllSubViewsAtView:(UIView *)view
{
    while (view.subviews.count) {
       [[view.subviews lastObject] removeFromSuperview];
    }
}

#pragma mark -- 显示、隐藏cell上的内容

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.hidden && self.swipeOverlayView && !self.swipeOverlayView.hidden) {
        //override hitTest to give swipe buttons a higher priority (diclosure buttons can steal input)
        UIView * targets[] = {self.leftSwipeView, self.rightSwipeView};
        for (int i = 0; i< 2; ++i) {
            UIView * target = targets[i];
            if (!target) continue;
            
            CGPoint p = [self convertPoint:point toView:target];
            if (CGRectContainsPoint(target.bounds, p)) {
                return [target hitTest:p withEvent:event];
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

/**
 * 显示self.swipeImageView
 */
- (void)showSwipeOverlayViewIfNeed
{
    if(self.isShowSwipeOverlayView) return;
    self.isShowSwipeOverlayView = YES;
    
    //显示swipeOverlayView,并将移动后cell上的内容裁剪到swipeImageView上
    self.swipeImageView.image = [self fecthTranslatedCellInfo:self];
    self.swipeOverlayView.hidden = NO;
    //隐藏cell上的内容
    [self hiddenAccesoryViewAndContentOfCellIfNeed:YES];
    //添加点击手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.delegate = self;
    [self.swipeImageView addGestureRecognizer:self.tapGesture];
}

/**
 *  隐藏self.swipeImageView
 */
- (void)hiddenSwipeOverlayViewIfNeed
{
    if(!self.isShowSwipeOverlayView) return;
    self.isShowSwipeOverlayView = NO;
    
    //隐藏swipeImageView
    self.swipeOverlayView.hidden = YES;
    self.swipeImageView.image = nil;
    
    //将cell上的内容还原
    [self hiddenAccesoryViewAndContentOfCellIfNeed:NO];
    //移除点击手势
    if(self.tapGesture){
        [self.swipeImageView removeGestureRecognizer:self.tapGesture];
        self.tapGesture = nil;
    }
}

/**
 *  是否隐藏accesoryView和cell上的内容,从而使得滑动cell时不会看见原有cell上的内容
 */
- (void)hiddenAccesoryViewAndContentOfCellIfNeed:(BOOL)hidden
{
    //若只设置self.accessoryType 则不走这个判断语句
    if(self.accessoryView){
        self.accessoryView.hidden = hidden;
    }
    
    //设置了self.accessoryType 其实是个UIButton
    for(UIView *subView in self.contentView.superview.subviews)
    {
        if(subView != self.contentView && ([subView isKindOfClass:[UIButton class]] || [NSStringFromClass(subView.class) rangeOfString:@"Disclosure"].location != NSNotFound))
        {
            subView.hidden = hidden;
        }
    }
    
    for(UIView *subView in self.contentView.subviews)
    {
        //若是cell上的subView则隐藏
        if(hidden && !subView.hidden)
        {
            subView.hidden = YES;
            [self.perviusHiddenViewSet addObject:subView];
        }
        //还原cell时，将隐藏的cell上的内容显示出来
        else if(!hidden && [self.perviusHiddenViewSet containsObject:subView])
        {
            subView.hidden = NO;
        }
    }
    if(!hidden){
        [self.perviusHiddenViewSet removeAllObjects];
    }
}

#pragma mark -- getter或setter

/**重写tableView的getter方法 获取cell所在的tableView*/
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
    UIView *currentSwipeView = swipeOffset < 0 ? self.rightSwipeView : self.leftSwipeView;
    
    _swipeOffset = swipeOffset;
    CGFloat offset = fabs(_swipeOffset);
    
    if(!currentSwipeView || offset == 0){
        [self hiddenSwipeOverlayViewIfNeed];
        self.targetOffset = 0.0;
        return;
    }
    else{
        [self showSwipeOverlayViewIfNeed];
        self.targetOffset = offset > currentSwipeView.bounds.size.width*self.swipeThreshold ? currentSwipeView.bounds.size.width*sign : 0;
    }
    NSLog(@"self.swipeOffset:%f", self.swipeOffset);
    //平移swipeImageView，显示滑动后cell的内容
    self.swipeImageView.transform = CGAffineTransformMakeTranslation(self.swipeOffset, 0);
    
    UIView *viewArray[2] = {self.rightSwipeView, self.leftSwipeView};
     for (int i = 0; i< 2; i++)
    {
        UIView *swipeView = viewArray[i];
        if(!swipeView) continue;
        
        //平移显示按钮
        CGFloat translation = MIN(offset, currentSwipeView.bounds.size.width)*sign;
        swipeView.transform = CGAffineTransformMakeTranslation(translation, 0);
        if(currentSwipeView != swipeView) continue;
    }
}

-(void)transitionStatic:(CGFloat)t
{
    const CGFloat dx = self.rightSwipeView.bounds.size.width * (1.0 - t);
    CGFloat offsetX = 0;
    
    for (UIView *button in self.rightSwipeButtons) {
        CGRect frame = button.frame;
        frame.origin.x = offsetX + -dx;
        button.frame = frame;
        offsetX += frame.size.width;
    }
}

#pragma mark -- 懒加载

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

- (NSMutableSet *)perviusHiddenViewSet
{
    if(!_perviusHiddenViewSet)
    {
        _perviusHiddenViewSet = [NSMutableSet set];
    }
    return _perviusHiddenViewSet;
}

@end
