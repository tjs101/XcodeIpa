//
//  XIProjectItem.m
//  XcodeIpa
//
//  Created by quentin on 2017/2/24.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "XIProjectItem.h"

@interface XIProjectItem ()

@property (nonatomic, strong, readwrite) NSURL *ipaPath;/**<ipa path>*/
@property (nonatomic, strong, readwrite) NSURL *uuidPath;/**<uuid path>*/
@property (nonatomic, strong, readwrite) NSURL *exportOptionsPlistPath;/**<exportOptionsPlist path>*/
@end

@implementation XIProjectItem

- (void)setProjectPath:(NSURL *)projectPath
{
    _projectPath = projectPath;
    
    [self setProjectRootDirectory:[self getFileDirectoryForFilePath:projectPath]];
}

#pragma mark - name

- (NSString *)name
{
    return _currentBuildScheme;
}

#pragma mark - url dir

- (NSURL *)getFileDirectoryForFilePath:(NSURL *)filePath
{
    NSArray *pathComponents = [filePath.relativePath pathComponents];
    NSString *fileDirectory = [NSString pathWithComponents:[pathComponents subarrayWithRange:NSMakeRange(0, pathComponents.count - 1)]];
    fileDirectory = [fileDirectory stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:fileDirectory];
}

#pragma mark - create local dir

- (void)createBuildDirectory
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd--HH-mm-ss"];
    NSString *currentTime = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *buildDirectoryPath = [_buildArchivePath.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", self.name, currentTime]];
    self.uuidPath = [NSURL URLWithString:[buildDirectoryPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:buildDirectoryPath withIntermediateDirectories:YES attributes:NULL error:&error];
    
    if (error == nil) {
        
        // build plist
        NSMutableDictionary *plistDict = [NSMutableDictionary dictionary];
        [plistDict setObject:self.name forKey:@"name"];
        [plistDict setObject:self.currentTeamID forKey:@"teamID"];
        [plistDict setObject:self.currentBuildScheme forKey:@"buildScheme"];
        [plistDict writeToFile:[buildDirectoryPath stringByAppendingPathComponent:@"build.plist"] atomically:YES];
        
        //archive path
        self.buildArchivePath = [NSURL URLWithString:[buildDirectoryPath stringByAppendingPathComponent:[[NSString stringWithFormat:@"%@.xcarchive", self.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        // ipa path
        self.ipaPath = [NSURL URLWithString:[buildDirectoryPath stringByAppendingPathComponent:[[NSString stringWithFormat:@"%@.ipa", self.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        // export options plist path
        
        self.exportOptionsPlistPath = [NSURL URLWithString:[buildDirectoryPath stringByAppendingPathComponent:[[NSString stringWithFormat:@"%@-ExportOptions.plist", self.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        NSMutableDictionary *optionsDict = [NSMutableDictionary dictionary];
        [optionsDict setValue:self.currentTeamID forKey:@"teamID"];
        [optionsDict writeToFile:self.exportOptionsPlistPath.absoluteString atomically:YES];
    }
    else {
        NSLogError(@"%@", error.description);
    }
}

@end
