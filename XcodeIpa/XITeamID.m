//
//  XITeamID.m
//  XcodeIpa
//
//  Created by quentin on 2017/2/25.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "XITeamID.h"

@implementation XITeamID

+ (NSArray *)allTeamIDs
{
    NSError *error = nil;
    NSArray *array = [self allKeychainCertificateWithError:&error];
    NSLog(@"all teamID - %@", array);
    NSMutableArray *certficate = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSLog(@"obj %@==", obj);
        
        NSDictionary *dict = nil;
        
        
        
    }];
    
    return nil;
}

+ (NSArray *)allKeychainCertificateWithError:(NSError **)error {
    
    NSDictionary *options = @{(id)kSecClass : (id)kSecClassCertificate,
                              (id)kSecMatchLimit : (id)kSecMatchLimitAll};
    
    CFArrayRef certs = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)options, (CFTypeRef *)&certs);
    NSArray *certificates = CFBridgingRelease(certs);
    if (status != errSecSuccess ||
        !certs) {
        return nil;
    }
    return certificates;
}

@end
