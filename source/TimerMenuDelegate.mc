using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Pomodoro;


/**
 * Delegate for the Timer Menu.
 **/
class TimerMenuDelegate extends Ui.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onBack() {
        //leave the menu
        Ui.popView(WatchUi.SLIDE_DOWN);
    }

    function onSelect(item as MenuItem) {
        var id = item.getId();
        if (id == :pomodoro) {
            showPicker(Rez.Strings.TimerPomodoroLabel, Props.POMODORO, 25);
        } else if (id == :shortBreak) {
            showPicker(Rez.Strings.TimerShortBreakLabel, Props.SHORT_BREAK, 25);
        } else if (id == :longBreak) {
            showPicker(Rez.Strings.TimerLongBreakLabel, Props.LONG_BREAK, 45);
        } else if (id == :longBreakAfter) {
            showPicker(Rez.Strings.TimerLongBreakAfterLabel, Props.POMODORO_GROUP, 10);
        }
    }

    private function showPicker(text, key, max) {
        Ui.pushView(new NumberPicker(text, key, max), new NumberPickerDelegate(key), Ui.SLIDE_IMMEDIATE);
    }
}
