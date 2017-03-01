//
//  XILogViewController.m
//  XcodeIpa
//
//  Created by quentin on 2017/2/28.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "XILogViewController.h"
#import "AppDelegate.h"

@interface XILogViewController ()

{
    BOOL  _autoScrollEnabled;
}

@end

@implementation XILogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    _autoScrollEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowLogNotification:) name:kRefreshShowLogNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidLiveScrollNotification:) name:NSScrollViewDidLiveScrollNotification object:nil];
    
    [self refreshLog];
}

- (void)refreshLog
{
    if (_autoScrollEnabled) {
        AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
        _logTextView.string = delegate.log;
        
        [_logTextView scrollToEndOfDocument:self];
    }

}

#pragma mark - notification

- (void)refreshShowLogNotification:(NSNotification *)notification
{
    [self refreshLog];
}

- (void)scrollViewDidLiveScrollNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSScrollView class]] &&
        [notification.object isEqualTo:_logTextView.enclosingScrollView]) {
        
        // 获取bounds and visible Rect
        NSRect bounds = _logTextView.bounds;
        NSRect visibleRect = _logTextView.visibleRect;
        
        _autoScrollEnabled = NO;
        
        if (NSMaxY(visibleRect) - NSMaxY(bounds) == 0) {
            
            _autoScrollEnabled = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshLog];
            });
        }
    }
}

@end
