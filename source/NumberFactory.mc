using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// Factory that controls which numbers can be picked
class NumberFactory extends WatchUi.PickerFactory {

    private var start as Number;
    private var stop as Number;
    private var formatString as String;

    public function initialize(start as Number, stop as Number) {
        PickerFactory.initialize();

        self.start = start;
        self.stop = stop;
    }

    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        var value = getValue(index);

        var text = "No item";
        if (value instanceof Number) {
            text = value.format("%d");
        }
        var font = Graphics.FONT_NUMBER_MEDIUM;
        return new WatchUi.Text({:text=>text, :color=>Graphics.COLOR_WHITE, :font=>font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }

    public function getValue(index as Number) as Object? {
        return index + 1;
    }

    (:test)
    function testGetValue(logger) {
        logger.debug("It should return 2 value for index 1.");
        var instance = new NumberFactory(1, 25);
        return  instance.getValue(1) == 2;
    }

    public function getSize() as Number {
        return (stop - start) + 1;
    }

    (:test)
    function testGetSize(logger) {
        logger.debug("It should return 25 for size.");
        var instance = new NumberFactory(1, 25);
        return instance.getSize() == 25;
    }
}
