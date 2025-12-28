import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.System;
import Toybox.Application.Properties;

class plyoActivityDelegate extends WatchUi.BehaviorDelegate {

    private var _view as plyoActivityView;

    public function initialize(view as plyoActivityView) {
        BehaviorDelegate.initialize();
        _view = view;
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

            // Create and show pause menu
            var menu = new WatchUi.Menu2({:title=>"Activity Paused"});
            menu.addItem(new WatchUi.MenuItem("Resume", null, :resume, null));
            menu.addItem(new WatchUi.MenuItem("Save", null, :save, null));
            menu.addItem(new WatchUi.MenuItem("Discard", null, :discard, null));

            WatchUi.switchToView(menu, new plyoPauseMenuDelegate(_view.session, _view.timeAtLastLap, _view.setCount), WatchUi.SLIDE_LEFT);

        }
        return true;
    }

    // Handle up button to add a lap
    public function onBack() as Boolean {
        _view.addLap();
        System.println("resting: " + Properties.getValue("resting"));
        return true;
    }
}