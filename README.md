# PomodoroTimer
An implementation of the [Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) for Garmin wearables. Inspired by [Garmodoro](https://github.com/klimeryk/garmodoro), however this PomodoroTimer has no support for handheld devices.

## Features
* Keeps track of time left in your Pomodoro session, as well as break time and overal number of Pomodoros.
* Alerts you using vibrations and tones (if supported by device).
* Vizualisation of the countdown as a circle.
* Possibility to stop the timer and continue.
* You can customize a lot of aspects:
   * duration of one Pomodoro (default: 25 minutes)
   * duration of the short break between Pomodoros (default: 5 minutes)
   * duration of the long break between groups of Pomodoros (default: 30 minutes)
   * the number of Pomodoros in a group (default: 4)
   * alert on change from Pomodoro to break and vice versa
   * color of a Pomodoro session, break and ready state (when supported by device)

## Development

To run the project, you just need the SDK and the Monkey C plugin for Visual Studio Code.

There are two Shell scripts for testing:
* test_all: runs the test for all devices found in the manifest.xml
* test: runs the test for one device which can be passed as an argument (default is venu2plus)