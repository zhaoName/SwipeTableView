//
//  SwipeAnimation.m
//  SwipeTableView
//
//  Created by zhao on 16/8/27.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "SwipeAnimation.h"

static inline CGFloat mgEaseLinear(CGFloat t, CGFloat b, CGFloat c) {
    return c*t + b;
}

static inline CGFloat mgEaseInQuad(CGFloat t, CGFloat b, CGFloat c) {
    return c*t*t + b;
}
static inline CGFloat mgEaseOutQuad(CGFloat t, CGFloat b, CGFloat c) {
    return -c*t*(t-2) + b;
}
static inline CGFloat mgEaseInOutQuad(CGFloat t, CGFloat b, CGFloat c) {
    if ((t*=2) < 1) return c/2*t*t + b;
    --t;
    return -c/2 * (t*(t-2) - 1) + b;
}
static inline CGFloat mgEaseInCubic(CGFloat t, CGFloat b, CGFloat c) {
    return c*t*t*t + b;
}
static inline CGFloat mgEaseOutCubic(CGFloat t, CGFloat b, CGFloat c) {
    --t;
    return c*(t*t*t + 1) + b;
}
static inline CGFloat mgEaseInOutCubic(CGFloat t, CGFloat b, CGFloat c) {
    if ((t*=2) < 1) return c/2*t*t*t + b;
    t-=2;
    return c/2*(t*t*t + 2) + b;
}
static inline CGFloat mgEaseOutBounce(CGFloat t, CGFloat b, CGFloat c) {
    if (t < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        t-=(1.5/2.75);
        return c*(7.5625*t*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        t-=(2.25/2.75);
        return c*(7.5625*t*t + .9375) + b;
    } else {
        t-=(2.625/2.75);
        return c*(7.5625*t*t + .984375) + b;
    }
};
static inline CGFloat mgEaseInBounce(CGFloat t, CGFloat b, CGFloat c) {
    return c - mgEaseOutBounce (1.0 -t, 0, c) + b;
};

static inline CGFloat mgEaseInOutBounce(CGFloat t, CGFloat b, CGFloat c) {
    if (t < 0.5) return mgEaseInBounce (t*2, 0, c) * .5 + b;
    return mgEaseOutBounce (1.0 - t*2, 0, c) * .5 + c*.5 + b;
};

@implementation SwipeAnimation

-(instancetype) init {
    if (self = [super init]) {
        _duration = 0.3;
        _mode =  SwipeViewTransfromModeDefault;
        _easingFunction = MGSwipeEasingFunctionCubicOut;
    }
    return self;
}

//手势动画效果
-(CGFloat)value:(CGFloat)elapsed duration:(CGFloat)duration from:(CGFloat)from to:(CGFloat)to
{
    CGFloat t = MIN(elapsed/duration, 1.0f);
    if (t == 1.0) {
        return to;
    }
    CGFloat (*easingFunction)(CGFloat t, CGFloat b, CGFloat c) = 0;
    switch (_easingFunction) {
        case MGSwipeEasingFunctionLinear: easingFunction = mgEaseLinear; break;
        case MGSwipeEasingFunctionQuadIn: easingFunction = mgEaseInQuad;;break;
        case MGSwipeEasingFunctionQuadOut: easingFunction = mgEaseOutQuad;;break;
        case MGSwipeEasingFunctionQuadInOut: easingFunction = mgEaseInOutQuad;break;
        case MGSwipeEasingFunctionCubicIn: easingFunction = mgEaseInCubic;break;
        default:
        case MGSwipeEasingFunctionCubicOut: easingFunction = mgEaseOutCubic;break;
        case MGSwipeEasingFunctionCubicInOut: easingFunction = mgEaseInOutCubic;break;
        case MGSwipeEasingFunctionBounceIn: easingFunction = mgEaseInBounce;break;
        case MGSwipeEasingFunctionBounceOut: easingFunction = mgEaseOutBounce;break;
        case MGSwipeEasingFunctionBounceInOut: easingFunction = mgEaseInOutBounce;break;
    }
    return (*easingFunction)(t, from, to - from);
}

//swipeView的演出动画效果
- (void)swipeView:(UIView *)swipeView swipeButtons:(NSArray *)buttons fromRight:(BOOL)fromRight effect:(CGFloat)t cellHeight:(CGFloat)cellHeight
{
    switch (self.mode)
    {
        case SwipeViewTransfromModeDefault:break; //默认的效果
        case SwipeViewTransfromModeBorder:
        {
            CGFloat selfWidth = swipeView.bounds.size.width;
            CGFloat offsetX = 0;
            
            [self removeAllSubViewsAtView:swipeView];
            for (UIButton *button in buttons)
            {
                CGRect frame = button.frame;
                CGFloat x = fromRight ? offsetX * t :(selfWidth - MAX(frame.size.width, cellHeight) - offsetX) * (1.0 - t) + offsetX;
                frame = CGRectMake(x, 0,  MAX(frame.size.width, cellHeight), cellHeight);
                button.frame = frame;
                offsetX += MAX(frame.size.width, cellHeight);
                //直接用addSubview会覆盖左滑的动画效果
                [swipeView insertSubview:button atIndex:fromRight ? swipeView.subviews.count : 0];
            }
            break;
        }
        case SwipeViewTransfromMode3D:
        {
            const CGFloat invert = fromRight ? -1.0 : 1.0;
            const CGFloat angle = M_PI_2 * (1.0 - t) * invert;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0/400.0f;
            const CGFloat dx = -MAX(swipeView.frame.size.width, cellHeight) * 0.5 * invert;
            const CGFloat offset = dx * 2 * (1.0 - t);
            transform = CATransform3DTranslate(transform, dx - offset, 0, 0);
            transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
            transform = CATransform3DTranslate(transform, -dx, 0, 0);
            swipeView.layer.transform = transform;
            
             NSLog(@"%f, %f, %f", t, dx, offset);
            break;
        }
    }
}


- (void)removeAllSubViewsAtView:(UIView *)view
{
    while (view.subviews.count) {
        [[view.subviews lastObject] removeFromSuperview];
    }
}



@end
