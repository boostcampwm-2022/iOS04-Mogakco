#!/bin/sh

#  SwiftLintRunScript.sh
#  Manifests
#
#  Created by 오 국 원 on 2022/11/15.
#

export PATH="$PATH:/opt/homebrew/bin"
if which swiftlint >/dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download form https://github.com/realm/SwiftLint"
fi
