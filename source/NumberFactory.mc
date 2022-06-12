import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Factory that controls which numbers can be picked
class NumberFactory extends WatchUi.PickerFactory {
    private var start as Number;
    private var stop as Number;
    private var increment as Number;
    private var formatString as String;

    public function initialize(start as Number, stop as Number, increment as Number) {
        PickerFactory.initialize();

        self.start = start;
        self.stop = stop;
        self.increment = increment;
        formatString = "%d";
    }

    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        var value = getValue(index);

        var text = "No item";
        if (value instanceof Number) {
            text = value.format(formatString);
        }
        var font = Graphics.FONT_NUMBER_MEDIUM;
        return new WatchUi.Text({:text=>text, :color=>Graphics.COLOR_WHITE, :font=>font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }

    public function getIndex(value as Number) as Number {
        return (value / increment) - start;
    }

    (:test)
    function testGetIndex(logger) {
        logger.debug("It should return 2 for index.");
        var instance = new NumberFactory(1, 25, 1);
        return  instance.getIndex(3) == 2;
    }

    public function getValue(index as Number) as Object? {
        return start + (index * increment);
    }

    (:test)
    function testGetValue(logger) {
        logger.debug("It should return 2 for value.");
        var instance = new NumberFactory(1, 25, 1);
        return  instance.getValue(1) == 2;
    }

    public function getSize() as Number {
        return (stop - start) / increment + 1;
    }

    (:test)
    function testGetSize(logger) {
        logger.debug("It should return 25 for size.");
        var instance = new NumberFactory(1, 25, 1);
        return  instance.getSize() == 25;
    }
}
