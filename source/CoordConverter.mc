using Toybox.Math;

/**
 * Module to convert between coordinate systems
 **/
module CoordConverter {

    function getCartesian(radius as Numeric, deg as Numeric) {
		var rad = Math.toRadians(deg);
		var x = radius * Math.cos(rad);
		var y = radius * Math.sin(rad);
		return [x, y];
	}

	(:test)
	function testGetCartesian(logger) {
		logger.debug("Test for getCartesian should return Cartesian coordinates.");
		var loc = getCartesian(1, 45);
		return loc[0].format("%.2f").equals("0.71") && loc[1].format("%.2f").equals("0.71");
	}
}