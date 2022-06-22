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
            showPicker(item, Props.POMODORO, 25);
        } else if (id == :shortBreak) {
            showPicker(item, Props.SHORT_BREAK, 25);
        } else if (id == :longBreak) {
            showPicker(item, Props.LONG_BREAK, 45);
        } else if (id == :longBreakAfter) {
            showPicker(item, Props.POMODORO_GROUP, 10);
        }
    }

    private function showPicker(item, key, max) {
        Ui.pushView(new NumberPicker(item.getLabel(), key, max),
            new NumberPickerDelegate(key, item), Ui.SLIDE_IMMEDIATE);
    }
}
