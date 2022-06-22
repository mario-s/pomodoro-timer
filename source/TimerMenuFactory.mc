using Toybox.WatchUi as Ui;

//factory to create the menu for timer settings
class TimerMenuFactory {

    private const keys = [Props.POMODORO, Props.SHORT_BREAK, Props.LONG_BREAK, Props.POMODORO_GROUP];
    private var labelFactory;

    function initialize() {
        labelFactory = new LabelFactory();
    }

    function create() {
        var menu = new Rez.Menus.TimerMenu();
        var m = keys.size();
        for(var i = 0; i < m; i++) {
            var lbl = labelFactory.create(keys[i]);
            menu.getItem(i).setSubLabel(lbl);
        }
        return menu;
    }

    (:test)
    function testCreate(logger) {
        logger.debug("It should create a menu where the items have a sublabel from properties.");
        var instance = new TimerMenuFactory();
        var menu = instance.create();
        var pomodoro = Props.getValue(Props.POMODORO).toString();
        return menu.getItem(0).getSubLabel().equals(pomodoro + " " + Ui.loadResource(Rez.Strings.Minutes));
    }
}

//factory to create a label which contains a value and a unit
class LabelFactory {

    private var minutes;

    function initialize() {
        minutes = " " + Ui.loadResource(Rez.Strings.Minutes);
    }

    function create(key as String) {
        var val = Props.getValue(key);
        var unit = getUnit(key);
        return val + unit;
    }

    private function getUnit(key as String) {
        if (key.equals(Props.POMODORO_GROUP)) {
            return "";
        }
        return minutes;
    }

    (:test)
    function testCreate(logger) {
        logger.debug("It should create a text which can be used as a label.");
        var instance = new LabelFactory();
        var pomodoroResult = instance.create(Props.POMODORO);
        var groupResult = instance.create(Props.POMODORO_GROUP);
        var pomodoro = Props.getValue(Props.POMODORO).toString();
        var group = Props.getValue(Props.POMODORO_GROUP).toString();
        return pomodoroResult.equals(pomodoro + " " + Ui.loadResource(Rez.Strings.Minutes)) && groupResult.equals(group);
    }
}