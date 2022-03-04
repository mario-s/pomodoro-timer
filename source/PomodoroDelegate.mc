using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.WatchUi as Ui;
using Toybox.Test;
using Pomodoro;


class PomodoroDelegate extends Ui.BehaviorDelegate {

	function initialize() {
		Ui.BehaviorDelegate.initialize();
	}

	function onBack() {
		Ui.popView(Ui.SLIDE_RIGHT);
		return true;
	}

	function onNextMode() {
		return true;
	}

	function onNextPage() {
		return true;
	}

	function onSelect() {
		if (Pomodoro.isReady()) {
			Pomodoro.start();
			Ui.requestUpdate();
		} else { // pomodoro is in running or break state
			onMenu();
		}

		return true;
	}

	(:test)
	function testOnSelect(logger) {
		logger.debug("Test for onSelect should change to state running.");
		PomodoroDelegate.onSelect();
		return Pomodoro.isRunning();
	}

	function onMenu() {
		Ui.pushView(new Rez.Menus.StopMenu(),
					new StopMenuDelegate(), Ui.SLIDE_UP);
		return true;
	}
}
