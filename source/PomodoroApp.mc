using Toybox.Application as App;
using Pomodoro;


class PomodoroApp extends App.AppBase {

	function initialize() {
		AppBase.initialize();
		Pomodoro.initialize();
	}

	(:test)
	function testInitialize(logger) {
		logger.debug("It should initialize the core module.");
		initialize();
		return Pomodoro.isReady();
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
