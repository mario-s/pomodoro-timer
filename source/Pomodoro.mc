using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;
using Toybox.Lang as Lang;

/**
 * Core module.
 **/
module Pomodoro {

    const SECOND = 60000;

	enum {
		READY,
		RUNNING,
		PAUSE
	}

	var minuteTimer;
	var tickTimer;
	var currentState = READY;
	var pomodoroIteration = 1;
	var minutesLeft = 0;
	// cached app properties to reduce battery load
	var tickStrength;
	var tickDuration;

	function initialize() {
		tickStrength = App.getApp().getProperty( "tickStrength" );
		tickDuration = App.getApp().getProperty( "tickDuration" );
	}

    function startTimers() {
        minuteTimer = new Timer.Timer();
		tickTimer = new Timer.Timer();

		// continuously refreshes current time displayed
		beginMinuteCountdown();
    }

	function vibrate(dutyCycle, length) {
		if (Attention has :vibrate) {
			Attention.vibrate([ new Attention.VibeProfile(
						dutyCycle, length ) ] );
		}
	}

	// if not muted
	function playAttentionTone(tone) {
		var isMuted =  App.getApp().getProperty( "muteSounds" );
		if ( ! isMuted && Attention has :playTone ) {
			Attention.playTone( tone );
		}
	}

	function isPaused() {
		return currentState == PAUSE;
	}

	function isRunning() {
		return currentState == RUNNING;
	}

	function isReady() {
		return currentState == READY;
	}

	function isLongBreak() {
		var groupLength = App.getApp().getProperty(
					"numberOfPomodorosBeforeLongBreak" );
		return ( pomodoroIteration % groupLength ) == 0;
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

	// for view
	function getMinutesLeft() {
		return minutesLeft.format("%02d");
	}

	// for view
	function getIteration() {
		return pomodoroIteration;
	}

	// called by StopMenuDelegate
	function resetFromMenu() {
		playAttentionTone(9); // Attention.TONE_RESET
		vibrate(50, 1500);

		pomodoroIteration = 0;
		transitionToState(READY);
	}

	function countdownMinutes() {
		minutesLeft -= 1;

		if (minutesLeft == 0) {
			if(isRunning()) {
				transitionToState(PAUSE);
			} else if (isPaused()) {
				transitionToState(READY);
			} else {
				// nothing to do in ready state
			}
		}

		Ui.requestUpdate();
	}

	function beginMinuteCountdown() {
		var countdown = new Lang.Method(Pomodoro, :countdownMinutes);
		minuteTimer.start(countdown, SECOND, true);
	}

	function makeTickingSound() {
		vibrate(tickStrength, tickDuration);
	}

	function shouldTick() {
		return App.getApp().getProperty( "tickStrength" ) > 0;
	}

	// one tick every second
	function beginTickingIfEnabled() {
		if (shouldTick()) {
			var makeTick = new Lang.Method(Pomodoro, :makeTickingSound);
			tickTimer.start(makeTick, 1000, true);
		}
	}

	function stopTimers() {
		tickTimer.stop();
		minuteTimer.stop();
	}

	function transitionToState(targetState) {
		stopTimers();
		currentState = targetState;

		if( targetState == READY ) {
			playAttentionTone(7); // Attention.TONE_INTERVAL_ALERT
			vibrate(100, 1500);

			pomodoroIteration += 1;
		} else if(targetState==RUNNING) {
			playAttentionTone(1); // Attention.TONE_START
			vibrate(75, 1500);

			resetPomodoroMinutes();
			beginTickingIfEnabled();
		} else { // targetState == PAUSE
			playAttentionTone(10); // Attention.TONE_LAP
			vibrate(100, 1500);

			resetPauseMinutes();
		}

		beginMinuteCountdown();
	}
}