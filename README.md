# PomodoroTimer
An implementation of the [Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) for Garmin wearables. Inspired by [Garmodoro](https://github.com/klimeryk/garmodoro), however this has no support for handheld devices.

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

## Development

To run the project, you just need the SDK and the Monkey C plugin for Visual Studio Code.
