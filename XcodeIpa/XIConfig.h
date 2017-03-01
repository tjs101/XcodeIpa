//
//  XIConfig.h
//  XcodeIpa
//
//  Created by quentin on 2017/2/24.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#ifndef XIConfig_h
#define XIConfig_h

#import <Foundation/Foundation.h>

//Log
#if DEBUG
#define NSLog(format, ...) NSLog(@"\n✅文件: %@ \n方法: %s \n内容: %@ \n行数: %d", [[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject],  __FUNCTION__, [NSString stringWithFormat:format, ##__VA_ARGS__], __LINE__);
#define NSLogWarning(format, ...) NSLog(@"\n⚠️文件: %@ \n方法: %s \n内容: %@ \n行数: %d", [[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject],  __FUNCTION__, [NSString stringWithFormat:format, ##__VA_ARGS__], __LINE__);
#define NSLogError(format, ...) NSLog(@"\n❌文件: %@ \n方法: %s \n内容: %@ \n行数: %d", [[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject],  __FUNCTION__, [NSString stringWithFormat:format, ##__VA_ARGS__], __LINE__);
#else
#define NSLog(format,...)
#define NSLogWarning(format, ...)
#define NSLogError(format, ...)
#endif

// show log
extern NSString * const kRefreshShowLogNotification;



#endif /* XIConfig_h */
