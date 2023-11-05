#!/bin/sh

#  build_number.sh
#  MenuBarCalculator
#
#  Created by Jared Schoeny on 11/4/23.
#  Copyright © 2023 Jared Schoeny. All rights reserved.

cd "$SOURCE_ROOT"

current_date=$(date +%Y%m%d)

previous_build_number=$(awk -F "=" '/BUILD_NUMBER/ {print $2}' Config.xcconfig | tr -d ' ')

previous_date="${previous_build_number:0:8}"
counter=${previous_build_number:8}

new_counter=$((current_date == previous_date ? counter + 1 : 1))
new_build_number="${current_date}${new_counter}"

sed -i -e "/BUILD_NUMBER =/ s/= .*/= $new_build_number/" Config.xcconfig

echo "Updated build number to $new_build_number"

rm -f Config.xcconfig-e
