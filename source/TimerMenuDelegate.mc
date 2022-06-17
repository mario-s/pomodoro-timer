using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Pomodoro;


/**
 * Delegate for the Stop Menu Item.
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
			var text = Rez.Strings.TimerPomodoroLabel;
			var prop = "pomodoroDuration";
			Ui.pushView(new IntervallPicker(text, prop), new NumberPickerDelegate(), Ui.SLIDE_IMMEDIATE);
		} else if (id == :shortBreak) {
			var text = Rez.Strings.TimerShortBreakLabel;
			var prop = "shortBreakDuration";
			Ui.pushView(new IntervallPicker(text, prop), new NumberPickerDelegate(), Ui.SLIDE_IMMEDIATE);
		} else if (id == :longBreak) {
			var text = Rez.Strings.TimerLongBreakLabel;
			var prop = "longBreakDuration";
			Ui.pushView(new IntervallPicker(text, prop), new NumberPickerDelegate(), Ui.SLIDE_IMMEDIATE);
		} else if (id == :longBreakAfter) {
			var text = Rez.Strings.TimerLongBreakAfterLabel;
			var prop = "pomodorosBeforeLongBreak";
			Ui.pushView(new CountPicker(text, prop), new NumberPickerDelegate(), Ui.SLIDE_IMMEDIATE);
		}
	}
}
