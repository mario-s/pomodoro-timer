using Toybox.Test;

/**
 * Mock for Toybox.Graphics.Dc.
 **/
(:debug)
class DcMock {

    private var width;
    private var height;
    private var invocations;

    function initialize() {
        self.width = 10;
        self.height = 10;
        self.invocations = [];
    }

    function getWidth() {
        return width;
    }

    function getHeight() {
        return height;
    }

    function setColor(alpha, color) {
        invocations.add("setColor");
    }

    function clear() {
        invocations.add("clear");
    }

    function drawText(x, y, font, text, justification) {
        Test.assert(text.length() > 0);
        invocations.add("drawText");
    }

    function fillCircle(x, y, radius) {
        Test.assert(radius > 1);
        invocations.add("fillCircle");
    }

    function setPenWidth(width) {
        Test.assert(width >= 1);
        invocations.add("setPenWidth");
    }

    function drawArc(x, y, radius, dir, start, end) {
        Test.assertEqual(start, Geometry.RECTANGULAR);
        invocations.add("drawArc");
    }

    function invoked(methods as Array) {
        var mSize = methods.size();

        for (var i = 0; i < mSize; i++) {
            var expected = methods[i];
            if (!contains(expected)) {
                return false;
            }
        }
        return true;
    }

    private function contains(expected) {
        var contains = false;
        var iSize = invocations.size();

        for (var i = 0; i < iSize; i++) {
            var actual = invocations[i];
            contains = actual.equals(expected);
            if (contains) {
                break;
            }
        }
        return contains;
    }

    (:test)
	function testInvoked(logger) {
		logger.debug("It should allow to verify that a number of methods are invoked.");
		var instance = new DcMock();
        instance.clear();
        instance.setPenWidth(2);
		return !instance.invoked(["clear", "foo"]);
	}
}