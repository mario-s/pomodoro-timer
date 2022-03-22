using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;
using CoordConverter;
using Pomodoro;


/**
 * Main App view.
 **/
class PomodoroView extends Ui.View {

	private const PEN_WIDTH = 2;

	private var minutes;
	private var shortBreakLabel;
	private var longBreakLabel;
	private var readyLabel;
	private var holdIcon;

	private var centerX;
	private var centerY;
	private var radius;

	private var pomodoroOffset;
	private var captionOffsetX;
	private var readyLabelOffset;
	private var minutesOffset;
	private var timeOffset;
	private var holdIconX;
	private var readyColor;
	private var pomodoroColor;
	private var breakColor;

	function initialize() {
		View.initialize();
	}

	function onLayout(dc) {
		loadResources();

		calculateLayout(dc.getWidth(), dc.getHeight());
	}

	private function loadResources() {
		minutes = Ui.loadResource(Rez.Strings.Minutes);
		shortBreakLabel = Ui.loadResource(Rez.Strings.ShortBreakLabel);
		longBreakLabel = Ui.loadResource(Rez.Strings.LongBreakLabel);
		readyLabel = Ui.loadResource(Rez.Strings.ReadyLabel);
		holdIcon = Ui.loadResource(Rez.Drawables.on_hold);

		var factory = new ColorFactory();
		readyColor = factory.getColorByProperty("readyColor");
		pomodoroColor = factory.getColorByProperty("pomodoroColor");
		breakColor = factory.getColorByProperty("breakColor");
	}

	private function calculateLayout(width, height) {
		self.centerX =  width / 2;
		self.centerY = height / 2;
		if (self.centerX < self.centerY) {
			radius = self.centerX - 4;
		} else {
			radius = self.centerY - 4;
		}

		calculateTopAndBottom(height);

		self.readyLabelOffset = self.centerY - (Gfx.getFontHeight(Gfx.FONT_LARGE) / 2);
		self.minutesOffset = self.centerY - (Gfx.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT) / 2);
		self.captionOffsetX = centerX + (centerX / 2);
		self.holdIconX = 30;
	}

	private function calculateTopAndBottom(height) {
		self.pomodoroOffset = 28;
		self.timeOffset = height - Gfx.getFontHeight(Gfx.FONT_NUMBER_MILD) - 15;
		var screenShape = System.getDeviceSettings().screenShape;
		if (System.SCREEN_SHAPE_RECTANGLE != screenShape) {
			self.pomodoroOffset += Gfx.getFontHeight(Gfx.FONT_MEDIUM) - 15;
			self.timeOffset -= 10;
		}
	}

	function onUpdate(dc) {
		clearView(dc);

		if (Pomodoro.isPaused()) {
			drawBreak(dc);
		} else if (Pomodoro.isRunning()) {
			drawRunning(dc);
		} else {
			drawReady(dc);
		}

		drawIcon(dc);
		drawTime(dc);
	}

	(:test)
	function testOnUpdate_Ready(logger) {
		logger.debug("It should update the layout for state ready.");
		var instance = new PomodoroView();
		var mock = new DcMock();
		instance.onLayout(mock);
		instance.onUpdate(mock);
		return true;
	}

	(:test)
	function testOnUpdate_Running(logger) {
		logger.debug("It should update the layout for state running.");
		Pomodoro.initialize();
		Pomodoro.startTimer();
		var instance = new PomodoroView();
		var mock = new DcMock();
		instance.onLayout(mock);
		Pomodoro.start();
		instance.onUpdate(mock);
		return true;
	}

	private function clearView(dc) {
		dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
		dc.clear();
	}

	private function drawBreak(dc) {
		var color = Pomodoro.isOnHold() ? Gfx.COLOR_LT_GRAY : breakColor;
		withColor(dc, color);
		drawCountdown(dc);

		var label = Pomodoro.isLongBreak() ? self.longBreakLabel : self.shortBreakLabel;
		dc.drawText(self.centerX, self.pomodoroOffset, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_CENTER);
		drawMinutes(dc);
	}

	private function drawRunning(dc) {
		drawStage(dc);

		var color = Pomodoro.isOnHold() ? Gfx.COLOR_LT_GRAY : pomodoroColor;
		withColor(dc, color);
		drawCountdown(dc);
		drawMinutes(dc);
	}

	private function drawReady(dc) {
		drawStage(dc);
		withColor(dc, readyColor);
		dc.drawText(self.centerX, self.readyLabelOffset, Gfx.FONT_LARGE, self.readyLabel, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawStage(dc) {
		var label = "Pomodoro #" + Pomodoro.iteration;
		withColor(dc, Gfx.COLOR_LT_GRAY);
		dc.drawText(self.centerX, self.pomodoroOffset, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawCountdown(dc) {
		var deg = Pomodoro.getArcDegree();
		var loc = getCircleLocation(deg);
		dc.fillCircle(loc[0], loc[1], 3);
		dc.setPenWidth(PEN_WIDTH);
		dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, CoordConverter.RECTANGULAR, deg);
	}

	private function getCircleLocation(deg as Numeric) {
		var loc = CoordConverter.toCartesian(self.radius, deg);
		var x = self.centerX + loc[0];
		var y = self.centerY - loc[1];
		return [x, y];
	}

	private function drawMinutes(dc) {
		var minutesAsText = Pomodoro.getMinutesLeft().format("%02d");
		dc.drawText(self.centerX, self.minutesOffset, Gfx.FONT_NUMBER_THAI_HOT, minutesAsText, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(self.captionOffsetX, self.centerY, Gfx.FONT_TINY, self.minutes, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawTime(dc) {
		withColor(dc, Gfx.COLOR_LT_GRAY);
		dc.drawText(self.centerX, self.timeOffset, Gfx.FONT_NUMBER_MILD, getTime(), Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function withColor(dc as Graphics.Dc, color) {
		dc.setColor(color, Gfx.COLOR_TRANSPARENT);
	}

	private function getTime() {
		var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
		return Lang.format("$1$:$2$", [
			today.hour.format("%02d"),
			today.min.format("%02d")
		]);
	}

	private function drawIcon(dc) {
		if (Pomodoro.isOnHold()) {
			dc.drawBitmap(self.holdIconX, self.centerY, holdIcon);
		}
	}
}
