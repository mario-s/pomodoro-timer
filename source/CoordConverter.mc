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
		logger.debug("Test for toCartesian should return Cartesian coordinates.");
		var loc = toCartesian(1, 45);
		return loc[0].format("%.2f").equals("0.71") && loc[1].format("%.2f").equals("0.71");
	}

    function toArcDegree(intervalLength, intervalCountdown) {
        var d = FULL_ARC * (intervalLength - intervalCountdown) / intervalLength;
		return RECTANGULAR + Math.ceil(d);
    }

    (:test)
	function testToArcDegree(logger) {
		logger.debug("Test for toArcDegree should return degree of the arc.");
		var deg = toArcDegree(25000, 8000);
        logger.debug(deg);
		return deg == 334;
	}
}