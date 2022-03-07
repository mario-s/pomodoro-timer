using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Pomodoro;


/**
 * Delegate for the Stop Menu Item.
 **/
class StopMenuDelegate extends Ui.Menu2InputDelegate {

	function initialize() {
		Menu2InputDelegate.initialize();
	}

	function onBack() {
		//leave the menu
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

	function onSelect(item as MenuItem) {
		var id = item.getId();
		if (id == :restart) {
			//reset and show main screen again
			Pomodoro.reset();
			onBack();
			Ui.requestUpdate();
		} else if (id == :hold) {
			Pomodoro.onHold();
			// if continue we go immediatly back
			if (!Pomodoro.isOnHold()) {
				onBack();
				Ui.requestUpdate();
			}
		} else if (id == :exit) {
			//complete exit
			System.exit();
		}
	}
}
