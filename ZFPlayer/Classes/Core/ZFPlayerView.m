//
//  ZFPlayerView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPlayerView.h"
#import "ZFPlayer.h"

@interface ZFPlayerView ()

@property (nonatomic, weak) UIView *fitView;
@end

@implementation ZFPlayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setView:(UIView *)view {
    if (_view) [_view removeFromSuperview];
    _view = view;
    if (view != nil) [self addSubview:view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"======%@",NSStringFromCGRect(self.frame));
    self.view.frame = self.bounds;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // Determine whether you can receive touch events
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    // Determine if the touch point is out of reach
    if (![self pointInside:point withEvent:event]) return nil;
    NSInteger count = self.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childPoint withEvent:event];
        if (fitView) {
            return fitView;
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (CGSize)presentationSize {
    if (CGSizeEqualToSize(_presentationSize, CGSizeZero)) {
        _presentationSize = self.frame.size;
    }
    return _presentationSize;
}

- (CGSize)scaleSize {
    CGFloat videoWidth = self.presentationSize.width;
    CGFloat videoHeight = self.presentationSize.height;
    CGFloat screenScale = (CGFloat)(ZFPlayerScreenWidth/ZFPlayerScreenHeight);
    CGFloat videoScale = (CGFloat)(videoWidth/videoHeight);
    if (screenScale > videoScale) {
        CGFloat height = ZFPlayerScreenHeight;
        CGFloat width = (CGFloat)(height * videoScale);
        _scaleSize = CGSizeMake(width, height);
    } else {
        CGFloat width = ZFPlayerScreenWidth;
        CGFloat height = (CGFloat)(width / videoScale);
        _scaleSize = CGSizeMake(width, height);
    }
    
    return _scaleSize;
}

@end
