#!/bin/sh

#  BuildScript.sh
#  XcodeIpa
#
#  Created by quentin on 2017/2/23.
#  Copyright © 2017年 Quentin. All rights reserved.

cd "${1}"

if [[ "${2}" == *"xcodeproj" ]]
then

echo "Building Project..."
xcodebuild clean -project "${2}" -scheme "${3}" archive -archivePath "${4}"

else

echo "Building Workspace..."
xcodebuild clean -workspace "${2}" -scheme "${3}" archive -archivePath "${4}"

fi

echo "Creating IPA..."
xcodebuild -exportArchive -archivePath "${5}" -exportPath "${6}" -exportOptionsPlist "${7}"
