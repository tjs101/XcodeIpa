//
//  AppDelegate.m
//  XcodeIpa
//
//  Created by quentin on 2017/2/23.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "AppDelegate.h"

NSString * const kRefreshShowLogNotification = @"kRefreshShowLogNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self writeLog:@"Record log ..."];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)writeLog:(NSString *)log
{
    if (_log == nil) {
        _log = [[NSMutableString alloc] init];
    }
    [_log appendFormat:@"%@\n\n", log];
    
    NSLog(@"%@", log);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshShowLogNotification object:nil];
}

@end
