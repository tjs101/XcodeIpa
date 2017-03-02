//
//  XIHomeViewController.h
//  XcodeIpa
//
//  Created by quentin on 2017/2/24.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XIHomeViewController : NSViewController

@property (nonatomic, strong) IBOutlet NSPathControl *projectPathControl;/**<项目目录>*/
@property (nonatomic, strong) IBOutlet NSComboBox *buildTypeBox;/**<build type>*/
@property (nonatomic, strong) IBOutlet NSComboBox *buildSchemeBox;/**<build scheme选择>*/
@property (nonatomic, strong) IBOutlet NSComboBox *teamIdBox;/**<team id>*/
@property (nonatomic, strong) IBOutlet NSButton *archiveClickBtn;/**<生成>*/
@property (nonatomic, strong) IBOutlet NSButton *advancedClickBtn;/**<advanced>*/

@property (nonatomic, strong) IBOutlet NSTextField *versionField;/**<版本>*/


@property (nonatomic, strong) IBOutlet NSTextField *progressStatusLabel;/**<progress status>*/


@property (nonatomic, strong) IBOutlet NSPathControl *ipaPathControl;/**<ipa path control>*/

@end
