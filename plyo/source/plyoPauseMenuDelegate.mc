using Toybox.WatchUi;
using Toybox.ActivityRecording;

class plyoPauseMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _session;
    private var _timeAtLastLap = 0;
    private var _setCount = 0;

    function initialize(session, timeAtLastLap, setCount) {
        Menu2InputDelegate.initialize();
        _session = session;
        _timeAtLastLap = timeAtLastLap;
        _setCount = setCount;
    }

    function onSelect(item) {
        var id = item.getId();

        if (id == :resume) {
            // RESUME: Start recording again and go back to the Activity View
            _session.start();
            var view = new plyoActivityView(_session, _timeAtLastLap, _setCount);
            WatchUi.switchToView(view, new plyoActivityDelegate(view), WatchUi.SLIDE_RIGHT);

        } else if (id == :save) {
            // SAVE: Save data and return to the Start View (Idle)
            _session.save();
            _session = null; // Clean up
            var view = new plyoView();
            WatchUi.switchToView(view, new plyoDelegate(view), WatchUi.SLIDE_RIGHT);

        } else if (id == :discard) {
            // DISCARD: Delete data and return to the Start View (Idle)
            _session.discard();
            _session = null; // Clean up
            var view = new plyoView();
            WatchUi.switchToView(view, new plyoDelegate(view), WatchUi.SLIDE_RIGHT);
        }
    }
    
    // Handle the hardware "Back" button while in the menu
    function onBack() {
        // Usually, pressing back in the pause menu implies "Resume"
        _session.start();
        var view = new plyoActivityView(_session, _timeAtLastLap, _setCount);
        WatchUi.switchToView(view, new plyoActivityDelegate(view), WatchUi.SLIDE_RIGHT);
    }
}