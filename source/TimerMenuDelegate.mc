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
			Ui.pushView(new NumberPicker(text), new NumberPickerDelegate(), Ui.SLIDE_IMMEDIATE);
		}
	}
}
