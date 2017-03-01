//
//  XISystem.m
//  XcodeIpa
//
//  Created by quentin on 2017/2/28.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "XISystem.h"
#import "AppDelegate.h"

@implementation XISystem

+ (void)writeLog:(NSString *)log
{
    AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [delegate writeLog:log];
}

@end
