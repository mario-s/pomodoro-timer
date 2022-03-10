using Toybox.Application as App;
using Toybox.Graphics;

/**
 * Color factory.
 **/
class ColorFactory {

    function getColorByProperty(key as String) {
        var value = getProperty(key);
        return getColor(value);
    }

    (:test)
	function testGetColorByProperty(logger) {
		logger.debug("It should return a color from a property.");
        var instance = new ColorFactory();
		return instance.getColorByProperty("readyColor") != Graphics.COLOR_BLACK;
	}

    private function getProperty(key) {
        return App.getApp().getProperty(key);
    }

    private function getColor(index) {
        switch(index) {
            case 0:
                return Graphics.COLOR_BLUE;
            case 1:
                return Graphics.COLOR_GREEN;
            case 2:
                return Graphics.COLOR_ORANGE;
            case 3:
                return Graphics.COLOR_PINK;
            case 4:
                return Graphics.COLOR_RED;
            case 6:
                return Graphics.COLOR_YELLOW;
            default:
                return Graphics.COLOR_WHITE;
        }
    }
}