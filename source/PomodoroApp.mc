using Toybox.Application as App;
using Pomodoro;
using KPayApp.KPay as KPay;

var kpay;

/**
 * The entry point.
 **/
class PomodoroApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
        Pomodoro.initialize();
        kpay = new KPay.Core(KPAY_CONFIG);
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
