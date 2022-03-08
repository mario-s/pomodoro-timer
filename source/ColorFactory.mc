using Toybox.Application as App;
using Toybox.Graphics;

/**
 * Color factory.
 **/
class ColorFactory {

    function getColorByPropertyKey(key as String) {
        var value = App.getApp().getProperty(key);
        return getColor(value);
    }

    function getColor(hexVal as String) {
        var red = to255(hexVal.substring(0, 2));
        var green = to255(hexVal.substring(2, 4));
        var blue = to255(hexVal.substring(4, key.length()));
        return Graphics.createColor(0, red, green, blue);
    }

    (:test)
	function testGetColor(logger) {
		logger.debug("It should return a color for hexadec FF0000.");
        var instance = new ColorFactory();
		return instance.getColor("FFAA00") == 16755200;
	}

    function to255(hex as String) {
        var arr = hex.toCharArray();
        return toDez(arr[0].toString()) * 16  + toDez(arr[1].toString());
    }

    (:test)
	function testTo255(logger) {
		logger.debug("It should return 251 for hexadec FB.");
        var instance = new ColorFactory();
		return instance.to255("FB") == 251;
	}

    private function toDez(hex as String) {
        switch(hex.toLower()) {
            case "f":
                return 15;
            case "e":
                return 14;
            case "d":
                return 13;
            case "c":
                return 12;
            case "b":
                return 11;
            case "a":
                return 10;
            default:
                return hex.toLong();
        }
    }
}