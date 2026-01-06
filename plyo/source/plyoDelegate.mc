import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.System;
import Toybox.Application.Properties;

class plyoDelegate extends WatchUi.BehaviorDelegate {

    private var _session as Session?;
    private var _maxNumPages as Number = 5;

    public function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new plyoMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }

    public function onPreviousPage() as Boolean {
        var currentPage = Properties.getValue("currentPage") as Number;
        currentPage = (currentPage - 1 + _maxNumPages) % _maxNumPages;
        Properties.setValue("currentPage", currentPage);
        WatchUi.switchToView(pageToView(currentPage), me, WatchUi.SLIDE_UP);
        return true;
    }

    public function onNextPage() as Boolean {
        var currentPage = Properties.getValue("currentPage");
        currentPage = (currentPage + 1) % _maxNumPages;
        Properties.setValue("currentPage", currentPage);
        var newView = pageToView(currentPage);
        WatchUi.switchToView(newView, me, WatchUi.SLIDE_DOWN);
        return true;
    }

    // Handle select button to start/stop recording
    public function onSelect() as Boolean {
        // Start a session and switch to activity view
        _session = ActivityRecording.createSession({:name=>"Plyo Session", :sport=>Activity.SPORT_GENERIC});
        _session.start();
        System.println("Started Plyo Recording");
        Properties.setValue("resting", true);

        var view = new plyoActivityView(_session, 0, 0);
        WatchUi.switchToView(view, new plyoActivityDelegate(view), WatchUi.SLIDE_LEFT);

        return true;
    }

}