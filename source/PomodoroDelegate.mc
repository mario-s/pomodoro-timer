using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.WatchUi as Ui;
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
			Pomodoro.transitionToState(Pomodoro.RUNNING);
			Ui.requestUpdate();
		} else { // pomodoro is in running or break state
			onMenu();
		}

		return true;
	}

	function onMenu() {
		Ui.pushView(new Rez.Menus.StopMenu(),
					new StopMenuDelegate(), Ui.SLIDE_UP);
		return true;
	}
}
