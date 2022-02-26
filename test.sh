#!/bin/bash

if [ -d bin ]; then
    rm -Rf bin
fi
mkdir bin

monkeyc -d venu2plus -f monkey.jungle -o bin/pomodoro-timer.prg -y ~/develop/tools/mokey_c/developer_key --unit-test
connectiq
monkeydo bin/pomodoro-timer.prg venu2plus -t