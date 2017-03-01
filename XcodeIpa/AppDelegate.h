//
//  AppDelegate.h
//  XcodeIpa
//
//  Created by quentin on 2017/2/23.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSMutableString *log;/**<log>*/

- (void)writeLog:(NSString *)log;// 写入log

@end

