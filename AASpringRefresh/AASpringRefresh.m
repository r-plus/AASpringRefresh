//
//  AASpringRefresh.m
//  AASpringRefreshDemo
//
//  Created by hyde on 2015/02/13.
//  Copyright (c) 2015年 r-plus. All rights reserved.
//

#import "AASpringRefresh.h"
#import "AASpringExpandView.h"

@interface UIView(Private)
- (NSString *)recursiveDescription;
@end

@interface AASpringRefresh ()
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL isUserAction;
@property (nonatomic, strong) NSArray *springExpandViews;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) AASpringRefreshState state;
- (instancetype)initWithPosition:(AASpringRefreshPosition)position;
@end

@implementation UIScrollView (AASpringRefresh)
- (AASpringRefresh *)addSpringRefreshPosition:(AASpringRefreshPosition)position
                                actionHandler:(void (^)(AASpringRefresh *springRefresh))handler
{
    // Don't add two instance to same position.
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[AASpringRefresh class]])
            if (((AASpringRefresh *)v).position == position)
                return (AASpringRefresh *)v;
    }
    
    AASpringRefresh *springRefresh = [[AASpringRefresh alloc] initWithPosition:position];
    springRefresh.scrollView = self;
    springRefresh.pullToRefreshHandler = handler;
    springRefresh.showed = YES;
    [self addSubview:springRefresh];
    return springRefresh;
}
@end

@implementation AASpringRefresh

- (instancetype)initWithPosition:(AASpringRefreshPosition)position
{
    if ((self = [super init])) {
        BOOL isSidePosition = (position == AASpringRefreshPositionLeft || position == AASpringRefreshPositionRight);
        _position = position;
        _unExpandedColor = [UIColor grayColor];
        _expandedColor = [UIColor blackColor];
        _readyColor = [UIColor redColor];
        _isUserAction = NO;
        _borderThickness = 6.0;
        _offsetMargin = 30.0;
        _affordanceMargin = 10.0;
        _threshold = 0;
        _text = nil;
        _state = AASpringRefreshStateUnExpanded;
        _size = (isSidePosition ? CGSizeMake(40.0, 60.0) : CGSizeMake(60.0, 40.0));
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0];
        _label.alpha = 0.0;
        // for safari.
        if (position == AASpringRefreshPositionBottom) {
            self.alpha = 0.0;
        }
        
        AASpringExpandView *springExpandView1 = [[AASpringExpandView alloc] initWithFrame:CGRectZero];
        springExpandView1.isSidePosition = isSidePosition;
        [self addSubview:springExpandView1];
        
        AASpringExpandView *springExpandView2 = [[AASpringExpandView alloc] initWithFrame:CGRectZero];
        springExpandView2.isSidePosition = isSidePosition;
        [self addSubview:springExpandView2];
        
        AASpringExpandView *springExpandView3 = [[AASpringExpandView alloc] initWithFrame:CGRectZero];
        springExpandView3.isSidePosition = isSidePosition;
        [self addSubview:springExpandView3];
        
        self.springExpandViews = @[springExpandView1, springExpandView2, springExpandView3];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // layout myself.
    switch (self.position) {
        case AASpringRefreshPositionTop: {
            CGRect frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - (self.size.width / 2.0), -self.affordanceMargin, self.size.width, self.size.height);
            if (self.text) {
                self.label.frame = CGRectMake((-self.scrollView.bounds.size.width+self.size.width)/2.0, 5.0, self.scrollView.frame.size.width, 15.0);
                //frame.origin.y -= 10.0;
            }
            self.frame = frame;
            break;
        }
        case AASpringRefreshPositionBottom: {
            CGFloat y = self.scrollView.contentSize.height;
/*            CGFloat y = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);*/
            self.frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - (self.size.width / 2.0), y + self.affordanceMargin, self.size.width, self.size.height);
            if (self.text) {
                self.label.frame = CGRectMake((-self.scrollView.bounds.size.width+self.size.width)/2.0, -20.0, self.scrollView.frame.size.width, 15.0);
                //frame.origin.y -= 10.0;
            }
            if (self.frame.origin.y > 100.0) {
                self.alpha = 1.0;
            }
            break;
        }
        case AASpringRefreshPositionLeft:
            self.frame = CGRectMake(-self.affordanceMargin, CGRectGetMidY(self.scrollView.bounds) - (self.size.height / 2.0), self.size.width, self.size.height);
            break;
        case AASpringRefreshPositionRight: {
            CGFloat x = MAX(self.scrollView.bounds.size.width, self.scrollView.contentSize.width);
            self.frame = CGRectMake(x + self.affordanceMargin, CGRectGetMidY(self.scrollView.bounds) - (self.size.height / 2.0), self.size.width, self.size.height);
            break;
        }
        default:
            break;
    }
    
    BOOL isSidePosition = (self.position == AASpringRefreshPositionLeft || self.position == AASpringRefreshPositionRight);
    CGFloat interItemSpace = (isSidePosition ? 40.0 : 40.0) / self.springExpandViews.count;
    
    // layout affordance.
    NSInteger index = 0;
    for (AASpringExpandView *springExpandView in self.springExpandViews) {
        switch (self.position) {
            case AASpringRefreshPositionTop:
                springExpandView.frame = CGRectMake(0.0, -interItemSpace * index, CGRectGetWidth(self.bounds), self.borderThickness);
                break;
            case AASpringRefreshPositionBottom:
                springExpandView.frame = CGRectMake(0.0, interItemSpace * index, CGRectGetWidth(self.bounds), self.borderThickness);
                break;
            case AASpringRefreshPositionLeft:
                springExpandView.frame = CGRectMake(-interItemSpace * index, 0.0, self.borderThickness, CGRectGetHeight(self.bounds));
                break;
            case AASpringRefreshPositionRight:
                springExpandView.frame = CGRectMake(interItemSpace * index, 0.0, self.borderThickness, CGRectGetHeight(self.bounds));
                break;
            default:
                break;
        }
        index++;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil)
        if (self.isShowed)
            self.showed = NO;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self setNeedsLayout];
    } else if ([keyPath isEqualToString:@"frame"]) {
        [self setNeedsLayout];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    // Do Action prev progress value.
    if (self.isUserAction && !self.scrollView.dragging && !self.scrollView.isZooming && self.progress > 0.99) {
        if (self.pullToRefreshHandler) {
            self.pullToRefreshHandler(self);
        }
    }
    
    CGFloat yOffset = contentOffset.y;
    CGFloat xOffset = contentOffset.x;
    
    switch (self.position) {
        case AASpringRefreshPositionTop: {
            CGFloat threshold = self.threshold != 0 ? self.threshold : CGRectGetHeight(self.bounds);
            self.progress = (-yOffset - self.offsetMargin - self.scrollView.contentInset.top) / threshold;
            if (self.text) {
                //CGPoint center = self.label.center;
                //center.y = -(yOffset / 6.0);
                //self.label.center = center;
                self.label.alpha = (-yOffset - self.scrollView.contentInset.top) / 40.0;
            }
            self.alpha = (-yOffset - self.scrollView.contentInset.top) / 40.0;
            break;
        }
        case AASpringRefreshPositionBottom: {
            CGFloat overBottomOffsetY = yOffset;
            CGFloat threshold = self.threshold != 0 ? self.threshold : CGRectGetHeight(self.bounds);
            if (self.scrollView.contentSize.height > self.scrollView.frame.size.height) {
                overBottomOffsetY += - self.scrollView.contentSize.height + self.scrollView.frame.size.height;
                self.progress = (overBottomOffsetY - self.offsetMargin - self.scrollView.contentInset.bottom) / threshold;
                if (self.text) {
                    //CGPoint center = self.label.center;
                    //center.y = MAX(self.scrollView.bounds.size.height, self.scrollView.contentSize.height) - (overBottomOffsetY / 6.0);
                    //self.label.center = center;
                    self.label.alpha = (overBottomOffsetY - self.scrollView.contentInset.bottom) / threshold;
                }
            } else {
                // have not scroll necessary height page on safari.

                // default is -64.0. bottom inset is 44.0;
                overBottomOffsetY += 20.0 + self.scrollView.contentInset.bottom;
                self.progress = (overBottomOffsetY - self.offsetMargin) / threshold;
                if (self.text) {
                    //CGPoint center = self.label.center;
                    //center.y = MAX(self.scrollView.bounds.size.height, self.scrollView.contentSize.height) - (overBottomOffsetY / 6.0);
                    //self.label.center = center;
                    self.label.alpha = (overBottomOffsetY) / threshold;
                }
            }
            break;
        }
        case AASpringRefreshPositionLeft: {
            CGFloat threshold = self.threshold != 0 ? self.threshold : CGRectGetWidth(self.bounds);
            self.progress = (-xOffset - self.offsetMargin) / threshold;
            break;
        }
        case AASpringRefreshPositionRight: {
            CGFloat rightEdgeOffset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
            CGFloat threshold = self.threshold != 0 ? self.threshold : CGRectGetWidth(self.bounds);
            self.progress = (xOffset - rightEdgeOffset - self.offsetMargin) / threshold;
            break;
        }
        default:
            break;
    }
    
    self.isUserAction = self.scrollView.dragging;
}

#pragma mark - Setter
- (void)setProgress:(CGFloat)progress
{
    // minus guard.
    progress = progress < 0 ? 0 : progress;
    _progress = progress;
    
    CGFloat progressInterval = 1.0 / self.springExpandViews.count;
    
    NSInteger index = 1;
    for (AASpringExpandView *springExpandView in self.springExpandViews) {
        BOOL expanded = ((index * progressInterval) <= progress);
        
        if (progress >= 1.0) {
            [springExpandView setColor:self.readyColor];
            self.label.textColor = self.readyColor;
            if (self.isUserAction && self.stateChangedHandler && self.state != AASpringRefreshStateReady) {
                self.state = AASpringRefreshStateReady;
                self.stateChangedHandler(self.state);
            }
        } else if (expanded) {
            [springExpandView setColor:self.expandedColor];
            if (self.isUserAction && self.stateChangedHandler && self.state != AASpringRefreshStateExpanded) {
                self.state = AASpringRefreshStateExpanded;
                self.stateChangedHandler(self.state);
            }
        } else {
            [springExpandView setColor:self.unExpandedColor];
            self.label.textColor = self.expandedColor;
            if (self.isUserAction && self.stateChangedHandler && self.state != AASpringRefreshStateUnExpanded) {
                self.state = AASpringRefreshStateUnExpanded;
                self.stateChangedHandler(self.state);
            }
        }
        
        [springExpandView setExpanded:expanded animated:YES];
        index++;
    }
}

- (void)setShowed:(BOOL)show
{
    self.hidden = !show;
    
    if (_showed != show) {
        if (show) {
            [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            _showed = YES;
        } else {
            [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
            [self.scrollView removeObserver:self forKeyPath:@"frame"];
            _showed = NO;
        }
    }
}

// for Sleipnizer only!
- (void)setObserver:(BOOL)add
{
    if (!_showed && add) {
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        _showed = YES;
    } else if (_showed && !add) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
        [self.scrollView removeObserver:self forKeyPath:@"frame"];
        _showed = NO;
    }
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self setNeedsLayout];
}

- (void)setBorderThickness:(CGFloat)borderThickness
{
    _borderThickness = borderThickness;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    if (text.length && (self.position == AASpringRefreshPositionTop || self.position == AASpringRefreshPositionBottom)) {
        // dont add multiple margin per change text.
        if (!self.text)
            self.affordanceMargin = self.affordanceMargin + 20.0;
        self.label.text = text;
        [self addSubview:self.label];
    } else {
        if (self.text)
            self.affordanceMargin = self.affordanceMargin - 20.0;
        [self.label removeFromSuperview];
    }
    _text = text;
    [self setNeedsLayout];
}
@end
