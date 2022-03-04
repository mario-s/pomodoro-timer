using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Pomodoro;


/**
 * Delegate for the Stop Menu Item.
 **/
class StopMenuDelegate extends Ui.Menu2InputDelegate {

	function initialize(menu as Menu2) {
		Menu2InputDelegate.initialize();

		// find hold item and align with field from Pomodoro
		var id = menu.findItemById(:hold);
		var holdItem = menu.getItem(id);
		holdItem.setEnabled(Pomodoro.isOnHold());
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
			//just hold progress, user can decide to leave menu
			Pomodoro.onHold();
		} else if (id == :exit) {
			//complete exit
			System.exit();
		}
	}
}
