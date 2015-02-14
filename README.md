AASpringRefresh
===============

All around Unread.app like pull to refresh library.

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
MIT
