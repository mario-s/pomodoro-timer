using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;
using Toybox.Lang as Lang;
using Toybox.Math;

/**
 * Core module.
 **/
module Pomodoro {

	const FULL_ARC = 360;
    const SECOND = 1000;
    const MINUTE = 60 * SECOND;

	enum {
		STATE_READY,
		STATE_RUNNING,
		STATE_PAUSE
	}

	var minutesTimer;
	var secondsTimer;
	var currentState = STATE_READY;
	var iteration = 1;
	var minutesLeft = 0;
	// length of the intervall in ms
	var intervalLength = 0;
	var intervalCountdown = 0;
	var tickStrength;
	var tickDuration;

	function initialize() {
		tickStrength = App.getApp().getProperty("tickStrength");
		tickDuration = App.getApp().getProperty("tickDuration");
	}

    function startTimers() {
        minutesTimer = new Timer.Timer();
		secondsTimer = new Timer.Timer();

		startSecondsTimer();
    }

	function startSecondsTimer() {
		var func = new Lang.Method(Pomodoro, :onSecondChanged);
		secondsTimer.start(func, SECOND, true);
	}

	function onSecondChanged() {
		intervalCountdown = intervalCountdown - SECOND;

        if (shouldTick()) {
		    vibrate(tickStrength, tickDuration);
        }

        Ui.requestUpdate();
	}

    function shouldTick() {
		return tickStrength > 0;
	}

	(:test)
	function testShouldTick(logger) {
		logger.debug("It should return false for shouldTick().");
		return !shouldTick();
	}

	function getCountdownDegree() {
		var deg = FULL_ARC * (intervalLength - intervalCountdown) / intervalLength;
		return Math.ceil(FULL_ARC - deg);
	}

	(:test)
	function testGetCountdownDegree_TenSeconds(logger) {
		logger.debug("It should return 358° when 10 seconds are past.");
		initInterval(25);
		for(var i = 0; i < 10; i++) {
			onSecondChanged();
		}
		return getCountdownDegree() == 358 && intervalCountdown == 1490000;
	}

    function startMinuteTimer() {
		var func = new Lang.Method(Pomodoro, :onMinuteChanged);
		minutesTimer.start(func, MINUTE, true);
	}

    function onMinuteChanged() {
		minutesLeft -= 1;

		if (minutesLeft == 0) {
			if(isRunning()) {
				transitionToState(STATE_PAUSE);
			} else if (isPaused()) {
				transitionToState(STATE_RUNNING);
			}
		}
	}

	(:test)
	function testOnMinuteChanged_ToPause(logger) {
		logger.debug("It should change to pause after a running state.");
		minutesLeft = 1;
		currentState = STATE_RUNNING;
		onMinuteChanged();
		return isPaused();
	}

	(:test)
	function testOnMinuteChanged_ToRun(logger) {
		logger.debug("It should change to running after a pause is completed.");
		minutesLeft = 1;
		currentState = STATE_PAUSE;
		onMinuteChanged();
		return isRunning()  && iteration == 2;
	}

	function isPaused() {
		return currentState == STATE_PAUSE;
	}

	function isRunning() {
		return currentState == STATE_RUNNING;
	}

	function isReady() {
		return currentState == STATE_READY;
	}

	function startFromMenu() {
		iteration = 0;
		transitionToState(STATE_RUNNING);
	}

	(:test)
	function testStartFromMenu(logger) {
		logger.debug("It should change to ready to running.");
		startFromMenu();
		return isRunning() && iteration == 1;
	}

	// called by StopMenuDelegate
	function resetFromMenu() {
		iteration = 0;
		transitionToState(STATE_READY);
	}

	(:test)
	function testResetFromMenu(logger) {
		logger.debug("It should change to ready on a reset from the menu.");
		iteration = 4;
		resetFromMenu();
		return isReady() && iteration == 1;
	}

	function transitionToState(targetState) {
		stopMinuteTimer();
		currentState = targetState;

		if(isReady()) {
			playTone(7);
			vibrate(100, 1500);

			iteration = 1;
		} else if(isRunning()) {
			playTone(1);
			vibrate(75, 1500);

			iteration += 1;
			resetPomodoroMinutes();
			startSecondsTimer();
		} else { // targetState == STATE_PAUSE
			playTone(10);
			vibrate(100, 1500);

			resetPauseMinutes();
		}

		startMinuteTimer();
	}

	function playTone(tone) {
		if (Attention has :playTone) {
			var isMuted =  App.getApp().getProperty("muteSounds");
			if (!isMuted) {
				Attention.playTone(tone);
			}
		}
	}

    function vibrate(dutyCycle, length) {
		if (Attention has :vibrate) {
			Attention.vibrate([new Attention.VibeProfile(
						dutyCycle, length)]);
		}
	}

	function resetPauseMinutes() {
		var breakVariant =  isLongBreak() ? "longBreakLength" : "shortBreakLength";
		initInterval(App.getApp().getProperty(breakVariant));
	}

	function isLongBreak() {
		var groupLength = App.getApp().getProperty("numberOfPomodorosBeforeLongBreak");
		return (iteration % groupLength) == 0;
	}

	function resetPomodoroMinutes() {
		initInterval(App.getApp().getProperty("pomodoroDuration"));
	}

	function initInterval(length) {
		minutesLeft = length;
		intervalLength = length * MINUTE;
		intervalCountdown = intervalLength;
	}

	function stopTimers() {
		secondsTimer.stop();
		stopMinuteTimer();
	}

	function stopMinuteTimer() {
		minutesTimer.stop();
	}
}
