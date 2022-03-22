using Toybox.Test;

/**
 * Mock for Toybox.Graphics.Dc.
 **/
(:debug)
class DcMock {

    private var width = 10;
    private var height = 10;

    function initialize() {
    }

    function getWidth() {
        return width;
    }

    function getHeight() {
        return height;
    }

    function setColor(alpha, color) {}

    function clear() {}

    function drawText(x, y, font, text, justification) {
        Test.assert(text.length() > 0);
    }

    function fillCircle(x, y, radius) {
        Test.assert(radius > 1);
    }

    function setPenWidth(width) {
        Test.assert(width > 1);
    }

    function drawArc(x, y, radius, dir, start, end) {
        Test.assertEqual(start, CoordConverter.RECTANGULAR);
    }
}