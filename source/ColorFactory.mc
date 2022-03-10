using Toybox.Application as App;
using Toybox.Graphics;

/**
 * Color factory.
 **/
class ColorFactory {

    function getColorByProperty(key as String) {
        if (isColorSupported()) {
            var value = getProperty(key);
            return getColor(value);
        }
        return Graphics.COLOR_WHITE;
    }

    function isColorSupported() {
        return Graphics has :createColor;
    }

    (:test)
	function testGetColorByProperty(logger) {
		logger.debug("It should return a color from a property.");
        var instance = new ColorFactory();
        if (instance.isColorSupported()) {
            return instance.getColorByProperty("readyColor") != Graphics.COLOR_WHITE;
        }
		return instance.getColorByProperty("readyColor") == Graphics.COLOR_WHITE;
	}

    private function getProperty(key) {
        return App.getApp().getProperty(key);
    }

    function getColor(hexVal as String) {
        var red = to255(hexVal.substring(0, 2));
        var green = to255(hexVal.substring(2, 4));
        var blue = to255(hexVal.substring(4, hexVal.length()));
        return Graphics.createColor(0, red, green, blue);
    }

    function to255(hex as String) {
        var arr = hex.toCharArray();
        try {
            return toDez(arr[0].toString()) * 16  + toDez(arr[1].toString());
        } catch (ex) {
            return 255;
        }
    }

    (:test)
	function testTo255_valid(logger) {
		logger.debug("It should return 251 for hexadec FB.");
        var instance = new ColorFactory();
		return instance.to255("FB") == 251;
	}

    (:test)
	function testTo255_invalidHex(logger) {
		logger.debug("It should return 255 for for invalid hex.");
        var instance = new ColorFactory();
		return instance.to255("XX") == 255;
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