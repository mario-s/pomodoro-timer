using Toybox.Math;

/**
 * Module to convert between coordinate systems.
 **/
module CoordConverter {

    const FULL_ARC = 360;
	const RECTANGULAR = 90;

    function toCartesian(radius as Numeric, deg as Numeric) {
		var rad = Math.toRadians(deg);
		var x = radius * Math.cos(rad);
		var y = radius * Math.sin(rad);
		return [x, y];
	}

	(:test)
	function testToCartesian(logger) {
		logger.debug("It should convert Polar coordinates into Cartesian coordinates.");
		var loc = toCartesian(1, 45);
		return loc[0].format("%.2f").equals("0.71") && loc[1].format("%.2f").equals("0.71");
	}

    function toArcDegree(intervalLength, intervalCountdown) {
        var d = FULL_ARC * (intervalLength - intervalCountdown) / intervalLength;
		return RECTANGULAR + Math.ceil(d);
    }

    (:test)
	function testToArcDegree(logger) {
		logger.debug("It should calculate the degree for the arc based on the interval.");
		var deg = toArcDegree(25000, 8000);
		return deg == 334;
	}
}