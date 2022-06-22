using Toybox.WatchUi as Ui;

//delegate to handle actions on the number picking UI
class NumberPickerDelegate extends Ui.PickerDelegate {

    private var key;
    private var item;
    private var labelFactory;

    public function initialize(key as String, item as MenuItem) {
        PickerDelegate.initialize();
        self.key = key;
        self.item = item;
        labelFactory = new LabelFactory();
    }

    public function onAccept(values as Array<Number?>) as Boolean {
        if (values.size() > 0) {
            var value = values[0];
            //order is important, first store the value, then read it again
            Props.setValue(key, value);
            var lbl = labelFactory.create(key);
            item.setSubLabel(lbl);
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
        var item = new TimerMenuFactory().create().getItem(0);
        //invoke instance and change
        var instance = new NumberPickerDelegate(key, item);
        instance.onAccept([5]);
        var changed = Props.getValue(key);

        //set back to origin
        Props.setValue(key, origin);
        return changed == 5;
    }
}
