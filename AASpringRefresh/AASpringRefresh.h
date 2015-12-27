//
//  AASpringRefresh.h
//  AASpringRefreshDemo
//
//  Created by hyde on 2015/02/13.
//  Copyright (c) 2015年 r-plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AASpringRefresh : UIView

typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, AASpringRefreshPosition) {
    AASpringRefreshPositionTop,
    AASpringRefreshPositionBottom,
    AASpringRefreshPositionLeft,
    AASpringRefreshPositionRight,
};

@property (nonatomic, strong) UIColor *unExpandedColor; // default: gray.
@property (nonatomic, strong) UIColor *expandedColor; // default: black.
@property (nonatomic, strong) UIColor *readyColor; // default: red.
@property (nonatomic, strong) NSString *text; // available for position Top or Bottom.
@property (nonatomic, assign) CGFloat borderThickness; // default: 6.0.
@property (nonatomic, assign) CGFloat affordanceMargin; // default: 10.0. to adjust space between scrollView edge and affordanceView.
@property (nonatomic, assign) CGFloat offsetMargin; // default: 30.0. to adjust threshold of offset.
@property (nonatomic, assign) CGFloat threshold; // default is width or height of size.
@property (nonatomic, assign) CGSize size; // to adjust expanded size and each interval space.
@property (nonatomic, assign, getter=isShowed) BOOL showed; // dynamic show/hide affordanceView and add/remove KVO observer.
@property (nonatomic, copy) void (^pullToRefreshHandler)(AASpringRefresh *springRefresh);
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, assign, readonly) AASpringRefreshPosition position;

-(void)setObserver:(BOOL)add;
@end

@interface UIScrollView (AASpringRefresh)
- (AASpringRefresh *)addSpringRefreshPosition:(AASpringRefreshPosition)position
                                actionHandler:(void (^)(AASpringRefresh *springRefresh))handler;
@end
