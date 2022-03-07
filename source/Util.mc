using Toybox.Application as App;

/**
 * Utility module.
 **/
module Util {

    function getProperty(key as String) {
        return App.getApp().getProperty(key);
    }

    function getColor(key as String) {
        var red = to255(key.substring(0, 2));
        var green = to255(key.substring(2, 4));
        var blue = to255(key.substring(4, key.length()));
        return red + green + blue;
    }

    (:test)
	function testGetColor(logger) {
		logger.debug("It should return a color for hexadec FFAABB.");
		return getColor("FFAABB") == 612;
	}

    function to255(hex as String) {
        var arr = hex.toCharArray();
        return toDez(arr[0].toString()) * 16  + toDez(arr[1].toString());
    }

    (:test)
	function testTo255(logger) {
		logger.debug("It should return 255 for hexadec FF.");
		return to255("FF") == 255;
	}

    function toDez(hex as String) {
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

    (:test)
	function testToDez(logger) {
		logger.debug("It should return 16 for hex F.");
		return toDez("10") == 10;
	}
}