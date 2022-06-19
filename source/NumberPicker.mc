using Toybox.WatchUi as Ui;
using Toybox.Application.Properties;

//Picker for numeric values
class NumberPicker extends Ui.Picker {

    public function initialize(text as String, prop as String, max as Number) {
         var title = new Ui.Text({:text=>text,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
            :font=>Graphics.FONT_TINY,
            :color=>Graphics.COLOR_WHITE});
        var factory = new NumberFactory(1, max);
        var index = self.getIndex(prop);
        Picker.initialize({
            :title=>title,
            :pattern=>[factory],
            :defaults=>[index]
            });
    }

    private function getIndex(prop as String) as Number {
        var index = Properties.getValue(prop);
        if (index <= 0) {
            index = 0;
        } else {
            index = index - 1;
        }
        return index;
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