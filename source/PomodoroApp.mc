using Toybox.Application as App;
using Pomodoro;

class PomodoroApp extends App.AppBase {

	function initialize() {
		AppBase.initialize();
		Pomodoro.initialize();
	}

	function onStart(state) {
		Pomodoro.startTimers();
	}

	function onStop(state) {
		Pomodoro.stopTimers();
	}

	function getInitialView() {
		return [new PomodoroView(), new PomodoroDelegate()];
	}
}
