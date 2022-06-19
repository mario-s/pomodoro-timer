using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Pomodoro;


/**
 * Delegate for the Main Menu.
 **/
class MainMenuDelegate extends Ui.Menu2InputDelegate {

	function initialize() {
		Menu2InputDelegate.initialize();
	}

	function onBack() {
		//leave the menu
        Ui.popView(WatchUi.SLIDE_DOWN);
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
		} else if (id == :timer) {
			var menu = initTimerMenu();
			Ui.pushView(menu, new TimerMenuDelegate(), WatchUi.SLIDE_UP);
		}
	}

	private function initTimerMenu() {
		var menu = new Rez.Menus.TimerMenu();
		var item = menu.getItem(0);
		var lbl = Props.getValue(Props.POMODORO).toString();
		item.setSubLabel(lbl);
		return menu;
	}
}
