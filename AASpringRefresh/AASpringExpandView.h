//
//  AASpringExpandView.h
//  AASpringRefreshDemo
//
//  Created by hyde on 2015/02/13.
//  Copyright (c) 2015年 r-plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AASpringExpandView : UIView

@property (nonatomic, assign) BOOL isSidePosition;
@property (nonatomic, assign, readonly, getter = isExpanded) BOOL expanded;
- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;
- (void)setColor:(UIColor *)color;

@end
