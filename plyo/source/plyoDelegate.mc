import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.System;
import Toybox.Application.Properties;

class plyoDelegate extends WatchUi.BehaviorDelegate {

    private var _session as Session?;
    public var mainView as plyoView;

    public function initialize(in_view as plyoView) {
        BehaviorDelegate.initialize();
        mainView = in_view;
    }

    public function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new plyoMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }

    public function onPreviousPage() as Boolean {
        mainView.previousPage();
        return true;
    }

    public function onNextPage() as Boolean {
        mainView.nextPage();
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