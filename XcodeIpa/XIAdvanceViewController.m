//
//  XIAdvanceViewController.m
//  XcodeIpa
//
//  Created by quentin on 2017/3/1.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import "XIAdvanceViewController.h"
#import "XISystem.h"
#import "XIProjectItem.h"
#import "XISettings.h"

@interface XIAdvanceViewController ()

@end

@implementation XIAdvanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // 蒲公英
    if ([XISettings sharedInstance].pyKey) {
        _pyKeyField.stringValue = [XISettings sharedInstance].pyKey;
        _pyApiKeyField.stringValue = [XISettings sharedInstance].pyApiKey;
    }

}

#pragma mark - on click

- (IBAction)onAdvancedClick:(id)sender
{
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = YES;
    if ([openPanel runModal] == NSModalResponseOK) {
        
        [XISystem writeLog:[NSString stringWithFormat:@"Archive Path:\n%@", openPanel.URL]];
        
        [XISettings sharedInstance].archivePath = openPanel.URL;

    }
}

- (IBAction)onSaveClick:(id)sender
{
    if ([sender isEqualTo:_pySaveBtn]) {// 蒲公英
        
        [XISettings sharedInstance].pyKey = _pyKeyField.stringValue;
        [XISettings sharedInstance].pyApiKey = _pyApiKeyField.stringValue;
    }
}

@end
