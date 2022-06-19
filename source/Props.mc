using Toybox.Application.Properties;

//module to bundle access to properties
module Props {

    const LONG_BREAK = "longBreakDuration";
    const SHORT_BREAK = "shortBreakDuration";
    const SOUND = "soundOnChange";
    const POMODORO = "pomodoroDuration";
    const POMODORO_GROUP = "pomodorosBeforeLongBreak";
    const VIBRATE = "vibrateOnChange";

    function getValue(key as String) {
        return Properties.getValue(key);
    }

    function setValue(key, value) {
        return Properties.setValue(key, value);
    }
}