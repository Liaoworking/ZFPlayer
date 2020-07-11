//
//  ZFFullScreenViewController.m
//  ZFPlayer
//
// Copyright (c) 2020年 任子丰 ( http://github.com/renzifeng )
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

#import "ZFLandscapeViewController.h"
#import "ZFPlayer.h"

@interface ZFLandscapeViewController ()

@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;
@property (nonatomic, readonly, getter=isRotating) BOOL rotating;

@end

@implementation ZFLandscapeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentOrientation = UIInterfaceOrientationPortrait;
        _statusBarStyle = UIStatusBarStyleLightContent;
        _statusBarAnimation = UIStatusBarAnimationSlide;
    }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    _rotating = YES;
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        self.currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    } else {
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(self.currentOrientation)) {
        if (self.rotateView.superview != self.view) {
            [self.view addSubview:self.rotateView];
            self.rotateView.frame = self.targetRect;
            [self.rotateView layoutIfNeeded];
        }
    }
    [self.delegate ls_willRotateToOrientation:self.currentOrientation];
    BOOL isFullscreen = size.width > size.height;
    [CATransaction begin];
    [CATransaction setDisableActions:self.disableAnimations];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        if (isFullscreen) {
            self.rotateView.frame = CGRectMake(0, 0, size.width, size.height);
        } else {
            self.rotateView.frame = self.targetRect;
        }
        [self.rotateView layoutIfNeeded];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        [CATransaction commit];
        self->_rotating = NO;
        [self.delegate ls_didRotateFromOrientation:self.currentOrientation];
    }];
}

- (BOOL)isFullscreen {
    return UIInterfaceOrientationIsLandscape(_currentOrientation);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return [self.delegate ls_shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.statusBarAnimation;
}

@end

