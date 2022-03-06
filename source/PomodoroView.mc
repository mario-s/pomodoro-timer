using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;
using Pomodoro;


/**
* Main App view.
**/
class PomodoroView extends Ui.View {

	private var remainingMinutes;
	private var remainingMinute;
	private var shortBreakLabel;
	private var longBreakLabel;
	private var readyLabel;

	private var centerX;
	private var centerY;
	private var radius;

	private var pomodoroOffset;
	private var captionOffset;
	private var readyLabelOffset;
	private var minutesOffset;
	private var timeOffset;

	function initialize() {
		View.initialize();
	}

	function onLayout(dc) {
		loadLabels();

		calculateLayout(dc.getWidth(), dc.getHeight());
	}

	private function loadLabels() {
		remainingMinutes = Ui.loadResource(Rez.Strings.RemainingMinutes);
		remainingMinute = Ui.loadResource(Rez.Strings.RemainingMinute);
		shortBreakLabel = Ui.loadResource(Rez.Strings.ShortBreakLabel);
		longBreakLabel = Ui.loadResource(Rez.Strings.LongBreakLabel);
		readyLabel = Ui.loadResource(Rez.Strings.ReadyLabel);
	}

	private function calculateLayout(width, height) {
		self.centerX =  width / 2;
		self.centerY = height / 2;
		if (centerY < centerY) {
			radius = centerY - 2;
		} else {
			radius = centerY - 2;
		}

		var mediumOffsetHalf = Gfx.getFontHeight(Gfx.FONT_MEDIUM) / 2;
		var mildOffset = Gfx.getFontHeight(Gfx.FONT_NUMBER_MILD);

		self.timeOffset = height - mildOffset;
		calculatePomodoroOffset();

		var largeFontHeight = Gfx.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT);
		self.readyLabelOffset = self.centerY - (Gfx.getFontHeight(Gfx.FONT_LARGE) / 2);
		self.minutesOffset = self.centerY - largeFontHeight / 2;
		self.captionOffset = self.minutesOffset + largeFontHeight + 5 - Gfx.getFontHeight(Gfx.FONT_TINY);
	}

	private function calculatePomodoroOffset() {
		self.pomodoroOffset = 5;
		var screenShape = System.getDeviceSettings().screenShape;
		if (System.SCREEN_SHAPE_RECTANGLE != screenShape) {
			self.pomodoroOffset += Gfx.getFontHeight(Gfx.FONT_MEDIUM);
			self.timeOffset -= 5;
		}
	}

	function onUpdate(dc) {
		clear(dc);

		if (Pomodoro.isPaused()) {
			drawBreak(dc);
		} else if (Pomodoro.isRunning()) {
			drawRunning(dc);
		} else {
			drawReady(dc);
		}

		drawTime(dc);
	}

	private function clear(dc) {
		dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
		dc.clear();
	}

	private function drawBreak(dc) {
		var color = Pomodoro.isOnHold() ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_GREEN;
		setColor(dc, color);
		drawCountdown(dc);

		var label = Pomodoro.isLongBreak() ? self.longBreakLabel : self.shortBreakLabel;
		dc.drawText(self.centerX, self.pomodoroOffset, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_CENTER);
		drawMinutes(dc);

		color = Pomodoro.isOnHold() ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_DK_GREEN;
		setColor(dc, color);
		drawRemainingLabel(dc);
	}

	private function drawRunning(dc) {
		drawStage(dc);

		var color = Pomodoro.isOnHold() ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_YELLOW;
		setColor(dc, color);
		drawCountdown(dc);
		drawMinutes(dc);

		color = Pomodoro.isOnHold() ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_ORANGE;
		setColor(dc, color);
		drawRemainingLabel(dc);
	}

	private function drawReady(dc) {
		drawStage(dc);
		setColor(dc, Gfx.COLOR_ORANGE);
		dc.drawText(self.centerX, self.readyLabelOffset, Gfx.FONT_LARGE, self.readyLabel, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawStage(dc) {
		var label = "Pomodoro #" + Pomodoro.iteration;
		setColor(dc, Gfx.COLOR_LT_GRAY);
		dc.drawText(self.centerX, self.pomodoroOffset, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawCountdown(dc) {
		var degreeEnd = Pomodoro.getCountdownDegree();
		dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, Pomodoro.RECTANGULAR, degreeEnd);
	}

	private function drawMinutes(dc) {
		var minutesAsText = Pomodoro.getMinutesLeft().format("%02d");
		dc.drawText(self.centerX, self.minutesOffset, Gfx.FONT_NUMBER_THAI_HOT, minutesAsText, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawRemainingLabel(dc) {
		var text = self.remainingMinutes;
		var minutes = Pomodoro.getMinutesLeft();
		if (minutes <= 1) {
			text = self.remainingMinute;
		}
		dc.drawText(self.centerX, self.captionOffset, Gfx.FONT_TINY, text, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawTime(dc) {
		setColor(dc, Gfx.COLOR_LT_GRAY);
		dc.drawText(self.centerX, self.timeOffset, Gfx.FONT_NUMBER_MILD, getTime(), Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function setColor(dc, color) {
		dc.setColor(color, Gfx.COLOR_TRANSPARENT);
	}

	private function getTime() {
		var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
		return Lang.format("$1$:$2$", [
			today.hour.format("%02d"),
			today.min.format("%02d")
		]);
	}
}
