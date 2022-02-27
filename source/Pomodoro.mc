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
	// 1 second in ms
    const SECOND = 1000;
	// 1 minute in ms
    const MINUTE = 60 * SECOND;

	enum {
		STATE_READY,
		STATE_RUNNING,
		STATE_PAUSE
	}

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
		secondsTimer = new Timer.Timer();

		startSecondsTimer();
    }

	function startSecondsTimer() {
		var func = new Lang.Method(Pomodoro, :onSecondChanged);
		secondsTimer.start(func, SECOND, true);
	}

	function onSecondChanged() {
		if (isRunning() || isPaused()) {
			intervalCountdown = intervalCountdown - SECOND;
		}

        if (shouldTick()) {
		    vibrate(tickStrength, tickDuration);
        }

		if (getMinutesLeft() == 0) {
			if(isRunning()) {
				transitionToState(STATE_PAUSE);
			} else if (isPaused()) {
				transitionToState(STATE_RUNNING);
			}
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
	function testGetCountdownDegree(logger) {
		logger.debug("It should return 358° when 10 seconds are past.");
		initInterval(25);
		currentState = STATE_RUNNING;
		for(var i = 0; i < 10; i++) {
			onSecondChanged();
		}
		return getCountdownDegree() == 358 && intervalCountdown == 1490000;
	}

	function getMinutesLeft() {
		return Math.ceil(intervalCountdown.toFloat() / MINUTE);
	}

	(:test)
	function testGetMinutesLeft_2Min(logger) {
		logger.debug("It should return 2 after 10 seconds past.");
		initInterval(2);
		startFromMenu();
		for(var i = 0; i < 10; i++) {
			onSecondChanged();
		}
		return getMinutesLeft() == 2;
	}

	(:test)
	function testGetMinutesLeft_1Min(logger) {
		logger.debug("It should return 1 after 60 seconds past.");
		initInterval(2);
		startFromMenu();
		for(var i = 0; i < 60; i++) {
			onSecondChanged();
		}
		return getMinutesLeft() == 1;
	}

	(:test)
	function testOnSecondChanged_ToPause(logger) {
		logger.debug("It should change to pause after a running state.");
		minutesLeft = 1;
		currentState = STATE_RUNNING;
		onSecondChanged();
		return isPaused();
	}

	(:test)
	function testOnSecondChanged_ToRun(logger) {
		logger.debug("It should change to running after a pause is completed.");
		minutesLeft = 1;
		currentState = STATE_PAUSE;
		onSecondChanged();
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
		} else { // targetState == STATE_PAUSE
			playTone(10);
			vibrate(100, 1500);

			resetPauseMinutes();
		}
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
	}
}
