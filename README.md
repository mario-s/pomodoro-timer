# PomodoroTimer
An implementation of the [Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) for Garmin wearables. Inspired by [Garmodoro](https://github.com/klimeryk/garmodoro), however this PomodoroTimer has no support for handheld devices.

![d2air](https://user-images.githubusercontent.com/4089975/159896378-b19684aa-29fa-4de7-af62-5cd078b2b802.png)
![venusq](https://user-images.githubusercontent.com/4089975/159896421-25b6a705-aba9-4dd6-9c97-d12c299f3df7.png)
![instinct2](https://user-images.githubusercontent.com/4089975/159896470-fd6cdc2f-c53c-4a55-ab52-441e64e3c406.png)
![fenix7s](https://user-images.githubusercontent.com/4089975/159896512-2b44a2c4-0e13-4087-b32a-f7a5bcd6e87d.png)

## Features
* Keeps track of time left in your Pomodoro session, as well as break time and overall number of Pomodoros.
* Alerts you with vibrations and tones (if supported by device).
* Visualization of the countdown as a circle.
* Possibility to stop the timer and continue.
* You can customize the following aspects:
   * duration of one Pomodoro (default: 25 minutes)
   * duration of the short break between Pomodoros (default: 5 minutes)
   * duration of the long break between groups of Pomodoros (default: 30 minutes)
   * the number of Pomodoros in a group (default: 4)
   * alert on change from Pomodoro to break and vice versa
   * color of a Pomodoro session, break and ready state (when supported by device)

## Development

To run the project, you just need the SDK and the Monkey C plugin for Visual Studio Code.

There are two Shell scripts for testing:
* `./test_all`: runs the test for all devices found in the manifest.xml
* `./test`: runs the test for one device which can be passed as an argument (default is venu2plus)

## Add new device

1. add your device to the `manifest.xml`
2. run the test with that device `./test <DEVICE_ID>`
3. If the device has a an icon size which is not yet supported, add a new resources.

### Icon Size
 Since there are a lot of wearable, which use an icon size of 40 x 40, this is the default size. If there are more than one waerables with same screen and icon size, it is better to use a resource, based on shape and screen size. For instance the folder `resource-round-416x416`is used by devices with a round screen and 416x416 screen size.
More about screen and icon size can be found in the [Device Reference.](https://developer.garmin.com/connect-iq/reference-guides/devices-reference/)

| Screen Shape | Screen Size | Icon Size |
| ------------ | ----------- | --------- |
| round        | 218 x 218   | 30 x 30   |
| rectangle    | 240 x 240   | 36 x 36   |
| round        | 260 x 260   | 35 x 35   |
| round        | 390 x 390   | 60 x 60   |
| round        | 416 x 416   | 70 x 70   |


The icon exists as a SVG and can be exported as a PNG with an appropriate size, using [Inkscape](https://inkscape.org) or [Vectornator](https://www.vectornator.io).
