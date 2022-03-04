using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Pomodoro;


/**
 * Delegate for the Stop Menu Item.
 **/
class StopMenuDelegate extends Ui.MenuInputDelegate {

	function initialize() {
		MenuInputDelegate.initialize();
	}

	function onMenuItem( item ) {
		if (item == :restart) {
			Pomodoro.reset();

			Ui.requestUpdate();
		} else if (item == :stop) {
			Pomodoro.onHold();
			Ui.requestUpdate();
		} else if (item == :exit) {
			System.exit();
		}
	}
}
