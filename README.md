# AASpringRefresh
[![CI Status](https://travis-ci.org/r-plus/AASpringRefresh.svg?branch=master)](https://travis-ci.org/r-plus/AASpringRefresh)
[![Version](https://img.shields.io/cocoapods/v/AASpringRefresh.svg?style=flat)](http://cocoadocs.org/docsets/AASpringRefresh)
[![License](https://img.shields.io/cocoapods/l/AASpringRefresh.svg?style=flat)](http://cocoadocs.org/docsets/AASpringRefresh)
[![Platform](https://img.shields.io/cocoapods/p/AASpringRefresh.svg?style=flat)](http://cocoadocs.org/docsets/AASpringRefresh)

All around Unread.app like pull to refresh library.

[[ http://f.cl.ly/items/2u1f3V190J3Z1t3E3d3T/Screen%20Recording%202015-02-15%20at%2011.27%20%E5%8D%88%E5%BE%8C.gif | width = 300px ]]

## Requirement
- ARC.
- iOS 7 or higher.

## Install
### CocoaPods
Add `pod 'AASpringRefresh'` to your Podfile.

### Manually

1. Copy `AASpringRefresh` directory to your project.

## Usage

    #import "AASpringRefresh.h"
    ...
    AASpringRefresh *springRefresh = [self.scrollView addSpringRefreshPosition:AASpringRefreshPositionTop actionHandler:^() {
        // do something...
    }];
    
### Customization
#### Property
You can customize below properties.

    springRefresh.unExpandedColor = [UIColor grayColor];
    springRefresh.expandedColor = [UIColor blackColor];
    springRefresh.readyColor = [UIColor redColor];
    springRefresh.text = @"REFRESH"; // available for position Top or Bottom.
    springRefresh.borderThickness = 6.0;
    springRefresh.affordanceMargin = 10.0; // to adjust space between scrollView edge and affordanceView.
    springRefresh.offsetMargin = 30.0; // to adjust threshold of offset.
    springRefresh.size = CGSizeMake(60.0, 40.0); // to adjust expanded size and each interval space.
    springRefresh.show = NO; // dynamic show/hide affordanceView and add/remove KVO observer.

## LICENSE
MIT License
