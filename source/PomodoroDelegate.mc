using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.WatchUi as Ui;
using Toybox.Test;
using Pomodoro;

/**
 * Class for main interaction with the app.
 * For instance it will start the Pomodoro or show a menu.
 **/
class PomodoroDelegate extends Ui.BehaviorDelegate {

	var menu;

	function initialize() {
		Ui.BehaviorDelegate.initialize();
		menu = new Rez.Menus.StopMenu();
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
		// find hold item and align with field from Pomodoro
		findHoldItem(menu).setEnabled(Pomodoro.isOnHold());
		Ui.pushView(menu, new StopMenuDelegate(), Ui.SLIDE_UP);
		return true;
	}

	function findHoldItem(menu as Menu2) {
		var id = menu.findItemById(:hold);
		return menu.getItem(id);
	}

	(:test)
	function testOnMenu(logger) {
		logger.debug("Test for onMenu should should enable toggle item when on hold.");
		var instance = new PomodoroDelegate();
		Pomodoro.onHold();
		instance.onMenu();
		return instance.findHoldItem(instance.menu).isEnabled();
	}
}
