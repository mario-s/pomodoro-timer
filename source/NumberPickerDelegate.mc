using Toybox.WatchUi as Ui;

//delegate to handle actions on the number picking UI
class NumberPickerDelegate extends Ui.PickerDelegate {

    private var key;

    public function initialize(key as String) {
        self.key = key;
        PickerDelegate.initialize();
    }

    public function onAccept(values as Array<Number?>) as Boolean {
        if (values.size() > 0) {
            var value = values[0];
            Props.setValue(key, value);
        }
        return onCancel();
    }

    public function onCancel() as Boolean {
        Ui.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    (:test)
	function testOnAccept(logger) {
		logger.debug("It should save a value into properties.");
		var key = Props.POMODORO;
        //keep origin value
        var origin = Props.getValue(key);

        //invoke instance and change
        var instance = new NumberPickerDelegate(key);
        instance.onAccept([5]);
        var changed = Props.getValue(key);

        //set back to origin
        Props.setValue(key, origin);
        return changed == 5;
	}
}
