using Toybox.Application as App;
using Pomodoro;

/**
 * The entry point.
 **/
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

	// on application start
	function onStart(state) {
		Pomodoro.startTimer();
	}

	// on application stop
	function onStop(state) {
		Pomodoro.stop();
	}

	function getInitialView() {
		return [new PomodoroView(), new PomodoroDelegate()];
	}
}
