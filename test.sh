#!/bin/bash

DEVICE=enduro
echo "Testing for $DEVICE"
if [ -d bin ]; then
    rm -Rf bin
fi
mkdir bin

monkeyc -d $DEVICE -f monkey.jungle -o bin/pomodoro-timer.prg -y ~/develop/tools/mokey_c/developer_key --unit-test
connectiq
monkeydo bin/pomodoro-timer.prg $DEVICE -t