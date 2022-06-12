using Toybox.WatchUi as Ui;
using Toybox.Application as App;

//Picker for numeric values
class NumberPicker extends Ui.Picker {

    public function initialize(text as String, prop as String) {
         var title = new Ui.Text({:text=>text,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
            :color=>Graphics.COLOR_WHITE});
        var factory = new NumberFactory(1, 25);
        var value = App.getApp().getProperty(prop);

        Picker.initialize({
            :title=>title,
            :pattern=>[factory],
            :defaults=>[value]
            });
    }

    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class NumberPickerDelegate extends Ui.PickerDelegate {

    public function initialize() {
        PickerDelegate.initialize();
    }

    public function onCancel() as Boolean {
        Ui.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    public function onAccept(values as Array<Number?>) as Boolean {
        //TODO save value into settings
        return true;
    }
}