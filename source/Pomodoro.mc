using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;
using Toybox.Lang as Lang;

/**
 * Core module.
 **/
module Pomodoro {

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
	// cached app properties to reduce battery load
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
		var func = new Lang.Method(Pomodoro, :onSecondUpdate);
		secondsTimer.start(func, SECOND, true);
	}

	function onSecondUpdate() {
        if (shouldTick()) {
		    vibrate(tickStrength, tickDuration);
        }
        Ui.requestUpdate();
	}

    function shouldTick() {
		return App.getApp().getProperty("tickStrength") > 0;
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
				transitionToState(STATE_READY);
			}
		}
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

	function transitionToState(targetState) {
		stopMinuteTimer();
		currentState = targetState;

		if(targetState == STATE_READY) {
			playTone(7);
			vibrate(100, 1500);

			iteration += 1;
		} else if(targetState == STATE_RUNNING) {
			playTone(1);
			vibrate(75, 1500);

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
		var isMuted =  App.getApp().getProperty("muteSounds");
		if (!isMuted && Attention has :playTone) {
			Attention.playTone(tone);
		}
	}

    function vibrate(dutyCycle, length) {
		if (Attention has :vibrate) {
			Attention.vibrate([new Attention.VibeProfile(
						dutyCycle, length)]);
		}
	}

	function isLongBreak() {
		var groupLength = App.getApp().getProperty("numberOfPomodorosBeforeLongBreak");
		return (iteration % groupLength) == 0;
	}

	function resetPauseMinutes() {
		var breakVariant =  isLongBreak() ?
					"longBreakLength" :
					"shortBreakLength";
		minutesLeft = App.getApp().getProperty(breakVariant);
	}

	function resetPomodoroMinutes() {
		minutesLeft = App.getApp().getProperty("pomodoroLength");
	}

	// called by StopMenuDelegate
	function resetFromMenu() {
		playTone(9);
		vibrate(50, 1500);

		iteration = 0;
		transitionToState(STATE_READY);
	}

	function stopTimers() {
		secondsTimer.stop();
		stopMinuteTimer();
	}

	function stopMinuteTimer() {
		minutesTimer.stop();
	}
}