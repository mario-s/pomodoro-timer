# PomodoroTimer
A lightweight and clean implementation of the [Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique). Inspired by [Garmodoro](https://github.com/klimeryk/garmodoro), however this is only for wearables, no support for handheld devices.

## Features
* Keeps track of time left in your Pomodoro session, as well as break time and overal number of Pomodoros.
* **Mimics the ticking of a real physical Pomodoro** by using short vibrations.
* Alerts you using vibrations and tones.
* You can customize many aspects of the technique:
   * length of one Pomodoro (default: 25 minutes)
   * length of the short break between Pomodoros (default: 5 minutes)
   * length of the long break between groups of Pomodoros (default: 30 minutes)
   * the number of Pomodoros in a group (default: 4)
   * the strength and duration of the vibration "tick" (set either to `0` to disable)

## Development

To run the project, you just need the SDK and the Monkey C plugin for Visual Studio Code.
