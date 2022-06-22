using Toybox.WatchUi as Ui;

//Picker for numeric values
class NumberPicker extends Ui.Picker {

    public function initialize(text as String, key as String, max as Number) {
         var title = new Ui.Text({:text=>text,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
            :font=>Graphics.FONT_TINY,
            :color=>Graphics.COLOR_WHITE});
        var factory = new NumberFactory(1, max);
        var index = self.getIndex(key);
        Picker.initialize({
            :title=>title,
            :pattern=>[factory],
            :defaults=>[index]
            });
    }

    private function getIndex(key as String) as Number {
        var index = Props.getValue(key);
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
