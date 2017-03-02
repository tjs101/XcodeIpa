#!/bin/sh

#  GetSchemeScript.sh
#  XcodeIpa
#
#  Created by quentin on 2017/2/23.
#  Copyright © 2017年 Quentin. All rights reserved.

cd "${1}"

xcodebuild -list -json
