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

	private var minutes;
	private var shortBreakLabel;
	private var longBreakLabel;
	private var readyLabel;
	private var holdIcon;

	private var centerX;
	private var centerY;
	private var radius;

	private var pomodoroOffset;
	private var captionOffset;
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
		readyColor = factory.getColorByPropertyKey("readyColor");
		pomodoroColor = factory.getColorByPropertyKey("pomodoroColor");
	}

	private function calculateLayout(width, height) {
		self.centerX =  width / 2;
		self.centerY = height / 2;
		if (centerY < centerY) {
			radius = centerY - 1;
		} else {
			radius = centerY - 1;
		}

		self.timeOffset = height - Gfx.getFontHeight(Gfx.FONT_NUMBER_MILD) - 5;
		calculatePomodoroOffset();

		var largeFontHeight = Gfx.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT);
		self.readyLabelOffset = self.centerY - (Gfx.getFontHeight(Gfx.FONT_LARGE) / 2);
		self.minutesOffset = self.centerY - largeFontHeight / 2;
		self.captionOffset = centerX + (centerX / 2);
		self.holdIconX = 30;
	}

	private function calculatePomodoroOffset() {
		self.pomodoroOffset = 20;
		var screenShape = System.getDeviceSettings().screenShape;
		if (System.SCREEN_SHAPE_RECTANGLE != screenShape) {
			self.pomodoroOffset += Gfx.getFontHeight(Gfx.FONT_MEDIUM);
			self.timeOffset -= 20;
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

	private function clearView(dc) {
		dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
		dc.clear();
	}

	private function drawBreak(dc) {
		var color = Pomodoro.isOnHold() ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_GREEN;
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
		var degreeEnd = Pomodoro.getCountdownDegree();
		dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, Pomodoro.RECTANGULAR, degreeEnd);
	}

	private function drawMinutes(dc) {
		var minutesAsText = Pomodoro.getMinutesLeft().format("%02d");
		dc.drawText(self.centerX, self.minutesOffset, Gfx.FONT_NUMBER_THAI_HOT, minutesAsText, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(self.captionOffset, self.centerY, Gfx.FONT_TINY, self.minutes, Gfx.TEXT_JUSTIFY_CENTER);
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
