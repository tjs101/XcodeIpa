//
//  XIHomeViewController.m
//  XcodeIpa
//
//  Created by quentin on 2017/2/24.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "XIHomeViewController.h"
#import "XIProjectItem.h"
#import "XITeamID.h"
#import "XISettings.h"
#import "XISystem.h"

typedef NS_ENUM(NSInteger, ScriptType)
{
    ScriptType_Project = 1,// 项目
    ScriptType_BuildScheme = 2 ,// build scheme
    ScriptType_TeamID = 3,// team id
    ScriptType_BuildArchive = 4,// build archive
};

@interface XIHomeViewController ()

{
    XIProjectItem  *_projectItem;
    
    ScriptType     _scriptType;
}

@end

@implementation XIHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // all teamID
    [XITeamID allTeamIDs];
    
    // project item
    _projectItem = [[XIProjectItem alloc] init];
    
    _projectItem.buildArchivePath = [XISettings sharedInstance].archivePath;
    
    // progress
    [self progressStatus:@"Init Data!"];
}

#pragma mark - progress status 

- (void)progressStatus:(NSString *)status
{
    _progressStatusLabel.stringValue = status;
}

#pragma mark - update view state

- (void)updateViewState
{
    // build scheme
    _buildSchemeBox.enabled = (
                               _projectPathControl.stringValue.length > 0 &&
                               [_projectItem.buildSchemes count] > 0);
    [_buildSchemeBox removeAllItems];
    [_buildSchemeBox addItemsWithObjectValues:_projectItem.buildSchemes];
    
    // build type
    _buildTypeBox.enabled = _buildSchemeBox.enabled;
    
    // team id
    _teamIdBox.enabled = _projectItem.currentTeamID > 0;
    if ([_teamIdBox.objectValues count] == 0 &&
        _projectItem.currentTeamID > 0) {
        [_teamIdBox addItemWithObjectValue:_projectItem.currentTeamID];
    }
    
    // archive
    _archiveClickBtn.enabled = (
                                _projectItem.projectPath.absoluteString.length > 0 &&
                                _projectItem.currentBuildScheme.length > 0 &&
                                _projectItem.currentTeamID.length > 0);
    
}

#pragma mark - on click

- (IBAction)onChooseProjectClick:(id)sender
{
    NSLog(@"path %@", _projectPathControl.URL);

    if (![_projectItem.projectPath isEqual:_projectPathControl.URL]) {
        
        [XISystem writeLog:[NSString stringWithFormat:@"Choose Project Path:\n%@", _projectPathControl.URL.absoluteString]];
        
        _projectItem.projectPath = _projectPathControl.URL;
        
        [self runGetSchemeScript:_projectItem.projectRootDirectory];
    }
}

- (IBAction)onBuildTypeChange:(id)sender
{
    if (![_projectItem.buildType isEqualToString:_buildTypeBox.stringValue]) {
        _projectItem.buildType = _buildTypeBox.stringValue;
        
        [XISystem writeLog:[NSString stringWithFormat:@"Choose BuildType:\n%@", _projectItem.buildType]];
    }
}

- (IBAction)onBuildSchemeChange:(id)sender
{
    if (![_projectItem.currentBuildScheme isEqualToString:_buildSchemeBox.stringValue]) {
        _projectItem.currentBuildScheme = _buildSchemeBox.stringValue;
        
        [XISystem writeLog:[NSString stringWithFormat:@"Select Build Scheme:\n%@", _projectItem.currentBuildScheme]];
        
        [self updateViewState];
    }

}

- (IBAction)onTeamIdChange:(id)sender
{
    if (![_projectItem.currentTeamID isEqualToString:_teamIdBox.stringValue]) {
        _projectItem.currentTeamID = _teamIdBox.stringValue;
        
        [XISystem writeLog:[NSString stringWithFormat:@"Select TeamID:\n%@", _projectItem.currentTeamID]];
        
        [self updateViewState];
    }
}

- (IBAction)onArchiveTapClick:(id)sender
{
    [XISystem writeLog:@"Start Archive Project..."];
    
    [self runBuildArchiveScript];
}

#pragma mark - sh

- (void)runGetSchemeScript:(NSURL *)url
{
    if (url) {
        
        _scriptType = ScriptType_BuildScheme;
        
        [XISystem writeLog:@"Get BuildSchemes..."];
        
        [self progressStatus:@"Get BuildSchemes..."];
        
        NSString *schemeScriptPath = [[NSBundle mainBundle] pathForResource:@"GetSchemeScript" ofType:@"sh"];
        [self runTaskWithLaunchPath:schemeScriptPath andArgument:@[url]];
    }
}

- (void)runTeamIDScript:(NSURL *)url
{
    if (url) {
        
        _scriptType = ScriptType_TeamID;
        
        [XISystem writeLog:@"Get TeamIDs..."];
        [self progressStatus:@"Get TeamIDs..."];
        
        NSString *teamIdScriptPath = [[NSBundle mainBundle] pathForResource:@"TeamIDScript" ofType:@"sh"];
        [self runTaskWithLaunchPath:teamIdScriptPath andArgument:@[url]];
    }
}

- (void)runXcodePathScript
{
    NSString *xcodePathSriptPath = [[NSBundle mainBundle] pathForResource:@"XCodePath" ofType:@"sh"];
    [self runTaskWithLaunchPath:xcodePathSriptPath andArgument:nil];
}

- (void)runBuildArchiveScript
{
    _scriptType = ScriptType_BuildArchive;
    
    [XISystem writeLog:@"Start Build Project..."];
    
    [self progressStatus:@"Start Build Project..."];
    
    [_projectItem createBuildDirectory];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProjectBuildScript" ofType:@"sh"];
    
    NSMutableArray *arguments = [NSMutableArray array];
    
    // ${1} project location
    [arguments addObject:_projectItem.projectRootDirectory];
    
    // ${2} project type xcworkspace/xcodeproj
    [arguments addObject:_projectPathControl.URL.lastPathComponent];
    
    // ${3} build scheme
    [arguments addObject:_projectItem.currentBuildScheme];
    
    // ${4} archive location
    [arguments addObject:_projectItem.buildArchivePath.resourceSpecifier];
    
    // ${5} archive location
    [arguments addObject:_projectItem.buildArchivePath.resourceSpecifier];
    
    // ${6} uuid location
    [arguments addObject:_projectItem.uuidPath.resourceSpecifier];
    
    // ${7} export options plist location
    [arguments addObject:_projectItem.exportOptionsPlistPath.resourceSpecifier];
    
    [self runTaskWithLaunchPath:path andArgument:arguments];
}

- (void)runTaskWithLaunchPath:(NSString *)launchPath andArgument:(NSArray *)arguments
{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = launchPath;
    if (arguments) {
        task.arguments = arguments;
    }
    [self captureStandardOutputWithTask:task];
    [task launch];
}

- (void)captureStandardOutputWithTask:(NSTask *)task
{
    NSPipe *outputPipe = [[NSPipe alloc] init];
    [task setStandardOutput:outputPipe];
    [task setStandardError:outputPipe];
    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outputPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSData *outputData =  outputPipe.fileHandleForReading.availableData;
        NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
        
        NSLog(@"outputString  %@", outputString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_scriptType == ScriptType_BuildScheme) {// build scheme
                
                NSError *error;
                NSDictionary *buildList = [NSJSONSerialization JSONObjectWithData:outputData options:NSJSONReadingAllowFragments error:&error];
                
                if (!error) {
                    NSLog(@"buildList %@", buildList);
                    
                    id value = [buildList objectForKey:@"project"];
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        
                        _projectItem.buildSchemes = [NSArray arrayWithArray:[value objectForKey:@"schemes"]];
                    }

                    [XISystem writeLog:[NSString stringWithFormat:@"Build schemes:\n%@", buildList.description]];
                }
                else {
                    [XISystem writeLog:@"Get Build Schemes failed!"];
                }
                
                [self updateViewState];
                
                [self runTeamIDScript:_projectItem.projectRootDirectory];
            }

            if (_scriptType == ScriptType_TeamID) {// team id
                
                if ([outputString.uppercaseString containsString:@"DEVELOPMENT_TEAM"]) {
                    
                    NSArray *component = [outputString componentsSeparatedByString:@"\n"];
                    NSString *teamId = [[component filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS 'DEVELOPMENT_TEAM'"]] firstObject];
                    if (teamId != nil) {

                        _projectItem.currentTeamID = [[teamId componentsSeparatedByString:@" = "] lastObject];
                        _teamIdBox.stringValue = _projectItem.currentTeamID;
                        
                        NSLog(@"team id = %@", _projectItem.currentTeamID);
                        
                        [XISystem writeLog:[NSString stringWithFormat:@"TeamIDs:\n%@", _projectItem.currentTeamID]];
                    }
                    else {
                        [XISystem writeLog:@"Get TeamID failed!"];
                    }
                }
                else if ([outputString.lowercaseString containsString:@"endteamid"] || outputString.lowercaseString.length == 0) {
                    [self progressStatus:@"Get TeamID successed!"];
                }
                else {
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                }
                
                [self updateViewState];
            }

            else if (_scriptType == ScriptType_BuildArchive)
            {// build archive
                if ([outputString.lowercaseString containsString:@"archive succeeded"]){

                    [self progressStatus:@"Export Project..."];
                    
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                } else if ([outputString.lowercaseString containsString:@"clean succeeded"]){
                    
                    [self progressStatus:@"Archive Project..."];
                    
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                } else if ([outputString.lowercaseString containsString:@"export succeeded"]){
                    //Check and Upload IPA File
                    [self progressStatus:@"Export IPA successed!"];
                    
                } else if ([outputString.lowercaseString containsString:@"export failed"]){

                    [self progressStatus:@"Export failed!"];
                    
                } else if ([outputString.lowercaseString containsString:@"archive failed"]){
                    [self progressStatus:@"Archive failed!"];
                } else {
                    
                    [XISystem writeLog:outputString];
                    
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                }
            }
        });
    }];
}


@end
