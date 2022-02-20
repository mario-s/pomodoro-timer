using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;

/**
 * Delegate for the Stop Menu Item.
 **/
class StopMenuDelegate extends Ui.MenuInputDelegate {

	function initialize() {
		MenuInputDelegate.initialize();
	}

	function onMenuItem( item ) {
		if (item == :restart) {
			play(9);
			ping(50, 1500);

			tickTimer.stop();
			timer.stop();

			resetMinutes();
			pomodoroNumber = 1;
			isPomodoroTimerStarted = false;
			isBreakTimerStarted = false;

			Ui.requestUpdate();
		} else if (item == :exit) {
			System.exit();
		}
	}
}
