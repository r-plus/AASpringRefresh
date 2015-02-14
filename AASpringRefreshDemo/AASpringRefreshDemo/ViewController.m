//
//  ViewController.m
//  AASpringRefreshDemo
//
//  Created by hyde on 2015/02/13.
//  Copyright (c) 2015年 r-plus. All rights reserved.
//

#import "ViewController.h"
#import "AASpringRefresh.h"

@interface ViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = self.view.bounds.size;
    [self.view addSubview:self.scrollView];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:nil];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.textContainerInset = UIEdgeInsetsMake(40.f, 20.f, 20.f, 20.f);
    self.textView.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.f];
    self.textView.textColor = [UIColor darkGrayColor];
    self.textView.editable = NO;
    self.textView.text = @"AASpringRefresh\n\n AASpringRefresh is Unread.app like pull-to-refresh library that can put to 4 direction (top/bottom/left/right).\n\n License under the MIT License.";
    //self.textView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.textView];
    
    // top
    AASpringRefresh *top = [self.scrollView addSpringRefreshPosition:AASpringRefreshPositionTop actionHandler:^ {
        NSLog(@"top");
    }];
    top.text = @"REFRESH";
    // bottom
    AASpringRefresh *bottom = [self.scrollView addSpringRefreshPosition:AASpringRefreshPositionBottom actionHandler:^ {
        NSLog(@"bottom");
    }];
    bottom.size = CGSizeMake(120.0, 40.0);
    bottom.text = @"Size property customized";
    // left
    AASpringRefresh *left = [self.scrollView addSpringRefreshPosition:AASpringRefreshPositionLeft actionHandler:^ {
        NSLog(@"left");
    }];
    left.unExpandedColor = [UIColor colorWithRed:0.80 green:0.93 blue:0.93 alpha:1.0];
    left.expandedColor = [UIColor colorWithRed:0.50 green:0.81 blue:1.00 alpha:1.0];
    left.readyColor = [UIColor colorWithRed:0.00 green:0.42 blue:1.00 alpha:1.0];
    // right
    AASpringRefresh *right = [self.scrollView addSpringRefreshPosition:AASpringRefreshPositionRight actionHandler:^ {
        NSLog(@"right");
    }];
    right.borderThickness = 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
