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

	private var pomodoroOffset;
	private var captionOffset;
	private var readyLabelOffset;
	private var minutesOffset;
	private var timeOffset;

	function initialize() {
		View.initialize();
	}

	function onLayout( dc ) {
		loadLabels();

		var height = dc.getHeight();
		centerX = dc.getWidth() / 2;
		centerY = height / 2;
		var mediumOffsetHalf = Gfx.getFontHeight(Gfx.FONT_MEDIUM) / 2;
		var mildOffset = Gfx.getFontHeight(Gfx.FONT_NUMBER_MILD);


		self.timeOffset = height - mildOffset;
		self.pomodoroOffset = 5;
		adjustOffsetForRoundScreen();

		self.readyLabelOffset = self.centerY - (Gfx.getFontHeight(Gfx.FONT_LARGE ) / 2);
		self.minutesOffset = self.centerY - (Gfx.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT ) / 2);
		self.captionOffset = self.timeOffset - Gfx.getFontHeight(Gfx.FONT_TINY) - 20;
	}

	private function loadLabels() {
		remainingMinutes = Ui.loadResource(Rez.Strings.RemainingMinutes);
		remainingMinute = Ui.loadResource(Rez.Strings.RemainingMinute);
		shortBreakLabel = Ui.loadResource(Rez.Strings.ShortBreakLabel);
		longBreakLabel = Ui.loadResource(Rez.Strings.LongBreakLabel);
		readyLabel = Ui.loadResource(Rez.Strings.ReadyLabel);
	}

	private function adjustOffsetForRoundScreen() {
		var screenShape = System.getDeviceSettings().screenShape;
		if (System.SCREEN_SHAPE_RECTANGLE != screenShape) {
			self.pomodoroOffset += Gfx.getFontHeight(Gfx.FONT_MEDIUM);
			self.timeOffset -= 5;
		}
	}

	function onUpdate(dc) {
		dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
		dc.clear();

		if (Pomodoro.isPaused()) {
			drawBreak(dc);
		} else if (Pomodoro.isRunning()) {
			drawRunning(dc);
		} else {
			drawReady(dc);
		}

		drawTime(dc);
	}

	private function drawBreak(dc) {
		var label = Pomodoro.isLongBreak() ? self.longBreakLabel : self.shortBreakLabel;
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		dc.drawText(self.centerX, self.pomodoroOffset, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_CENTER);
		drawMinutes(dc);
		dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);
		drawRemainingLabel(dc);
	}

	private function drawRunning(dc) {
		drawStage(dc);
		dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
		drawMinutes(dc);
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
		drawRemainingLabel(dc);
	}

	private function drawReady(dc) {
		drawStage(dc);
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(self.centerX, self.readyLabelOffset, Gfx.FONT_LARGE, self.readyLabel, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawStage(dc) {
		var label = "Pomodoro #" + Pomodoro.getIteration();
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawText(self.centerX, self.pomodoroOffset, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawMinutes(dc) {
		var minutesAsText = Pomodoro.getMinutesLeft();
		dc.drawText(self.centerX, self.minutesOffset, Gfx.FONT_NUMBER_THAI_HOT, minutesAsText, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawRemainingLabel(dc) {
		var text = self.remainingMinutes;
		var minutes = Pomodoro.minutesLeft;
		if (minutes <= 1) {
			text = self.remainingMinute;
		}
		dc.drawText(self.centerX, self.captionOffset, Gfx.FONT_TINY, text, Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function drawTime(dc) {
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawText(self.centerX, self.timeOffset, Gfx.FONT_NUMBER_MILD, self.getTime(), Gfx.TEXT_JUSTIFY_CENTER);
	}

	private function getTime() {
		var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
		return Lang.format("$1$:$2$", [
			today.hour.format("%02d"),
			today.min.format("%02d")
		]);
	}
}
