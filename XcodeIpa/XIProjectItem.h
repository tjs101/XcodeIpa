//
//  XIProjectItem.h
//  XcodeIpa
//
//  Created by quentin on 2017/2/24.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XIProjectItem : NSObject

@property (nonatomic, strong) NSURL *projectPath;/**<项目指定编译文件>*/
@property (nonatomic, strong) NSURL *projectRootDirectory;/**<项目目录>*/
@property (nonatomic, copy) NSString *buildType;/**<build type>*/
@property (nonatomic, strong) NSArray *buildSchemes;/**<build scheme>*/
@property (nonatomic, copy) NSString *currentBuildScheme;/**<current build scheme>*/
@property (nonatomic, strong, readonly) NSArray *allTeamIDs;/**<teamID>*/
@property (nonatomic, copy) NSString *currentTeamID;/**<current TeamID>*/
@property (nonatomic, copy, readonly) NSString *name;/**<name>*/

@property (nonatomic, strong) NSURL *buildArchivePath;/**<build archive path>*/
@property (nonatomic, strong) NSURL *ipaPath;/**<ipa path>*/
@property (nonatomic, strong, readonly) NSURL *uuidPath;/**<uuid path>*/
@property (nonatomic, strong, readonly) NSURL *exportOptionsPlistPath;/**<exportOptionsPlist path>*/

- (void)createBuildDirectory;// 创建导出目录

@end
