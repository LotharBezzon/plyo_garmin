import Toybox.Lang;
import Toybox.WatchUi;

class plyoDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new plyoMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}