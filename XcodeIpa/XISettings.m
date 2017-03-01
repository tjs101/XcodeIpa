//
//  XISettings.m
//  XcodeIpa
//
//  Created by quentin on 2017/2/27.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "XISettings.h"

@implementation XISettings

+ (XISettings *)sharedInstance
{
    static XISettings *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[XISettings alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - archivePath

- (void)setArchivePath:(NSURL *)archivePath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setURL:archivePath forKey:@"archivePath"];
    [defaults synchronize];
}

- (NSURL *)archivePath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{@"archivePath" : [NSURL URLWithString:[@"~/Desktop" stringByExpandingTildeInPath]]}];
    return [defaults URLForKey:@"archivePath"];
}

#pragma mark - pyKey

- (void)setPyKey:(NSString *)pyKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pyKey forKey:@"pyKey"];
    [defaults synchronize];
}

- (NSString *)pyKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"pyKey"];
}

#pragma mark - pyApiKey

- (void)setPyApiKey:(NSString *)pyApiKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pyApiKey forKey:@"pyApiKey"];
    [defaults synchronize];
}

- (NSString *)pyApiKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"pyApiKey"];
}

@end
