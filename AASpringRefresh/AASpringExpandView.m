//
//  AASpringExpandView.m
//  AASpringRefreshDemo
//
//  Created by hyde on 2015/02/13.
//  Copyright (c) 2015年 r-plus. All rights reserved.
//

#import "AASpringExpandView.h"

@interface AASpringExpandView ()

@property (nonatomic, strong) UIView *stretchingView;
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;

@end

@implementation AASpringExpandView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.stretchingView = [[UIView alloc] initWithFrame:CGRectZero];
        self.isSidePosition = NO; // safety.
        [self addSubview:self.stretchingView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self configureViewsForExpandedState:self.isExpanded animated:NO];
    self.stretchingView.layer.cornerRadius = self.isSidePosition ? CGRectGetMidX(self.stretchingView.bounds) : CGRectGetMidY(self.stretchingView.bounds);
}

#pragma mark - Public

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated
{
    if (self.isExpanded != expanded) {
        [self configureViewsForExpandedState:expanded animated:animated];
    }
}

- (void)setColor:(UIColor *)color
{
    self.stretchingView.backgroundColor = color;
}

#pragma mark - Private

- (void)configureViewsForExpandedState:(BOOL)expanded animated:(BOOL)animated
{
    if (expanded) {
        [self expandAnimated:animated];
    } else {
        [self collapseAnimated:animated];
    }
}

- (void)expandAnimated:(BOOL)animated
{
    void (^expandBlock)(void) = ^void() {
        self.stretchingView.frame = [self frameForExpandedState];
        self.expanded = YES;
    };
    
    if (animated) {
        [self performBlockInAnimation:expandBlock];
    } else {
        expandBlock();
    }
}

- (void)collapseAnimated:(BOOL)animated
{
    void (^collapseBlock)(void) = ^void() {
        self.stretchingView.frame = [self frameForCollapsedState];
        self.expanded = NO;
    };
    
    if (animated) {
        [self performBlockInAnimation:collapseBlock];
    } else {
        collapseBlock();
    }
}

- (void)performBlockInAnimation:(void(^)(void))blockToAnimate
{
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.55
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         blockToAnimate();
                     } completion:NULL];
}

#pragma mark - Helpers

- (CGRect)frameForCollapsedState
{
    if (self.isSidePosition)
        return CGRectMake(0.0, CGRectGetMidY(self.bounds) - (CGRectGetWidth(self.bounds) / 2.0), CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
    else
        return CGRectMake(CGRectGetMidX(self.bounds) - (CGRectGetHeight(self.bounds) / 2.0), 0.0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
}

- (CGRect)frameForExpandedState
{
    if (self.isSidePosition)
        return CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds));
    else
        return CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.0);
}

@end
