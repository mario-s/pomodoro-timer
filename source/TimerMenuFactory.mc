
//factory to create the menu for timer settings
class TimerMenuFactory {

    private var keys;
    private var menu;

    function initialize() {
        menu = new Rez.Menus.TimerMenu();
        keys = [Props.POMODORO, Props.SHORT_BREAK, Props.LONG_BREAK, Props.POMODORO_GROUP];
    }

    function create() {
        var m = keys.size();
        for(var i = 0; i < m; i++) {
            var key = keys[i];
            var val = Props.getValue(key).toString();
            //TODO localize and adopt to unit
			var lbl = val + " Minuten";
            menu.getItem(i).setSubLabel(lbl);
		}
		return menu;
	}

    (:test)
    function testCreate(logger) {
        logger.debug("It should create a menu where the items have a sublabel from properties.");
        var instance = new TimerMenuFactory();
        var menu = instance.create();
        var item = menu.getItem(0);
        var value = Props.getValue(Props.POMODORO).toString();
        return item.getSubLabel().find(value) != null;
    }
}