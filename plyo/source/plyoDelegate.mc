import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.System;

class plyoDelegate extends WatchUi.BehaviorDelegate {

    private var _view as plyoView;

    public function initialize(view as plyoView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    public function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new plyoMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    // Handle select button to start/stop recording
    public function onSelect() as Boolean {
        // Start a session if it doesn't exist or is not recording
        if (!_view.isSessionRecording()) {
            _view.startRecording();
            System.println("Started Plyo Recording");
        } 
        // Stop the session if it is recording
        else {
            _view.stopRecording();
            System.println("Stopped Plyo Recording");
        }
        return true;
    }
}