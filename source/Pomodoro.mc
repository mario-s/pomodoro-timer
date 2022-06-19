using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;
using Toybox.Lang as Lang;
using Toybox.Math;
using Geometry;


/**
 * Core module.
 **/
module Pomodoro {

    // 1 second in ms
    const SECOND = 1000;
    // 1 minute in ms
    const MINUTE = 60 * SECOND;

    enum {
        STATE_READY,
        STATE_RUNNING,
        STATE_PAUSE
    }

    var timer;

    // timer is on hold
    var hold = false;
    var currentState = STATE_READY;
    var iteration = 1;

    // length of the intervall in ms
    var intervalLength = 0;
    var intervalCountdown = 0;

    var isSoundOnChange = true;
    var isVibrateOnChange = true;

    function initialize() {
        isSoundOnChange =  Props.getValue(Props.SOUND);
        isVibrateOnChange = Props.getValue(Props.VIBRATE);

        timer = new Timer.Timer();
    }

    function startTimer() {
        var func = new Lang.Method(Pomodoro, :onSecondChanged);
        timer.start(func, SECOND, true);
    }

    function onSecondChanged() {
        if (isOnHold()) {
            // call update to change time
            Ui.requestUpdate();
        } else {
            countdown();

            Ui.requestUpdate();
        }
    }

    function countdown() {
        intervalCountdown = intervalCountdown - SECOND;

        if (intervalCountdown >= SECOND && intervalCountdown <= 3 * SECOND) {
            vibrate(100, 300);
        }

        if (getMinutesLeft() == 0) {
            if(isRunning()) {
                transitionToState(STATE_PAUSE);
            } else if (isPaused()) {
                transitionToState(STATE_RUNNING);
            }
        }
    }

    function getArcDegree() {
        return Geometry.toArcDegree(intervalLength, intervalCountdown);
    }

    (:test)
    function testgetArcDegree(logger) {
        logger.debug("It should return 92° when 10 seconds are past.");
        initInterval(25);
        currentState = STATE_RUNNING;
        for(var i = 0; i < 10; i++) {
            onSecondChanged();
        }
        return getArcDegree() == 92 && intervalCountdown == 1490000;
    }

    function getMinutesLeft() {
        return Math.ceil(intervalCountdown.toFloat() / MINUTE);
    }

    (:test)
    function testOnSecondChanged_Stop(logger) {
        logger.debug("It should not countdown when stopped.");
        initInterval(2);
        onHold();
        for(var i = 0; i < 60; i++) {
            onSecondChanged();
        }
        return getMinutesLeft() == 2;
    }

    (:test)
    function testGetMinutesLeft_2Min(logger) {
        logger.debug("It should return 2 after 10 seconds past.");
        initInterval(2);
        for(var i = 0; i < 10; i++) {
            onSecondChanged();
        }
        return getMinutesLeft() == 2;
    }

    (:test)
    function testGetMinutesLeft_1Min(logger) {
        logger.debug("It should return 1 after 60 seconds past.");
        initInterval(2);
        for(var i = 0; i < 60; i++) {
            onSecondChanged();
        }
        return getMinutesLeft() == 1;
    }

    (:test)
    function testOnSecondChanged_ToPause(logger) {
        logger.debug("It should change to pause after a running state.");
        currentState = STATE_RUNNING;
        onSecondChanged();
        return isPaused();
    }

    (:test)
    function testOnSecondChanged_ToRun(logger) {
        logger.debug("It should change to running after a pause is completed.");
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

    function start() {
        iteration = 0;
        transitionToState(STATE_RUNNING);
    }

    (:test)
    function testStart(logger) {
        logger.debug("It should change to ready to running.");
        start();
        return isRunning() && iteration == 1;
    }

    // called by StopMenuDelegate
    function reset() {
        iteration = 0;
        hold = false;
        transitionToState(STATE_READY);
    }

    (:test)
    function testReset(logger) {
        logger.debug("It should change to ready on a reset from the menu.");
        iteration = 4;
        onHold();
        reset();
        return isReady() && isOnHold() == false && iteration == 1;
    }

    function isOnHold() {
        return hold;
    }

    function onHold() {
        hold = !hold;
    }

    (:test)
    function testOnHold(logger) {
        logger.debug("It should change to stop state after a stop from the menu.");
        start();
        onHold();
        return isOnHold() && iteration == 1;
    }

    function continueFromMenu() {
        hold = false;
    }

    (:test)
    function testContinueFromMenu(logger) {
        logger.debug("It should change to last state after a stop.");
        start();
        onHold();
        continueFromMenu();
        return isRunning() && iteration == 1;
    }

    function transitionToState(targetState) {
        currentState = targetState;

        if(isReady()) {
            playTone(7);
            vibrate(100, SECOND);

            iteration = 1;
        } else if(isRunning()) {
            playTone(1);
            vibrate(75, SECOND);

            iteration += 1;
            resetPomodoroMinutes();
        } else if(isPaused()) {
            playTone(10);
            vibrate(100, SECOND);

            resetPauseMinutes();
        }
    }

    function playTone(tone) {
        if (Attention has :playTone && isSoundOnChange) {
            Attention.playTone(tone);
        }
    }

    function vibrate(dutyCycle, length) {
        if (Attention has :vibrate && isVibrateOnChange) {
            Attention.vibrate([new Attention.VibeProfile(
                        dutyCycle, length)]);
        }
    }

    function resetPauseMinutes() {
        var breakVariant =  isLongBreak() ? Props.LONG_BREAK : Props.SHORT_BREAK;
        initInterval(Props.getValue(breakVariant));
    }

    function isLongBreak() {
        var groupLength = Props.getValue(Props.POMODORO_GROUP);
        return (iteration % groupLength) == 0;
    }

    function resetPomodoroMinutes() {
        initInterval(Props.getValue(Props.POMODORO));
    }

    function initInterval(length) {
        intervalLength = length * MINUTE;
        intervalCountdown = intervalLength;
    }

    function stop() {
        timer.stop();
    }
}
