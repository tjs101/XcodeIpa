//
//  XIAdvanceViewController.h
//  XcodeIpa
//
//  Created by quentin on 2017/3/1.
//  Copyright © 2017年 Quentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XIAdvanceViewController : NSViewController

// 蒲公英
@property (nonatomic, strong) IBOutlet NSTextField *pyKeyField;/**<key>*/
@property (nonatomic, strong) IBOutlet NSTextField *pyApiKeyField;/**<api key>*/
@property (nonatomic, strong) IBOutlet NSButton    *pySaveBtn;/**<py save>*/

@end
