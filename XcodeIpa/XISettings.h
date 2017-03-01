//
//  XISettings.h
//  XcodeIpa
//
//  Created by quentin on 2017/2/27.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XISettings : NSObject

+ (XISettings *)sharedInstance;

@property (nonatomic, strong) NSURL *archivePath;/**<archive path>*/

// 蒲公英
@property (nonatomic, copy) NSString *pyKey;/**<pyKey>*/
@property (nonatomic, copy) NSString *pyApiKey;/**<py api key>*/

@end
