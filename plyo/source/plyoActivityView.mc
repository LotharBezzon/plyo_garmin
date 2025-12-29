import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.Lang;
import Toybox.Application.Properties;
import Toybox.Timer;

class plyoActivityView extends WatchUi.View {

    public var session as Session?;
    private var _plyoData as plyoData?;
    var resting as Boolean;
    public var timeAtLastLap = 0;
    private var _lapTime as Float = 0.0;
    private var _uiTimer as Timer.Timer;
    public var setCount as Number = 0;

    public function initialize(in_session as Session, in_timeAtLastLap as Number, in_setCount as Number) {
        View.initialize();
        session = in_session;
        _plyoData = new plyoData();
        resting = Properties.getValue("resting");
        System.println("initialize resting: " + resting);
        if (!resting) {
            _plyoData.enableAccel();
        }
        _uiTimer = new Timer.Timer();
        timeAtLastLap = in_timeAtLastLap;
        setCount = in_setCount;
    }

    function onShow() {
        // fire every 1000ms (1 second), repeat = true
        _uiTimer.start(method(:onRefreshUi), 1000, true);
    }

    function onHide() as Void {
        _uiTimer.stop();
    }

    function onRefreshUi() as Void {
        WatchUi.requestUpdate(); 
    }

    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.ActiveLayout(dc as Dc));
    }

    public function isSessionRecording(){
        return session.isRecording();
    }

    public function startRecording() as Void {
        session.start();
        WatchUi.requestUpdate();
    }

    public function stopRecording() as Void {
        if (isSessionRecording()) {
            session.stop();
            if (!Properties.getValue("resting")) {
                _plyoData.disableAccel();
            }
            WatchUi.requestUpdate();
        }
    }

    public function addLap() as Void {
        if (isSessionRecording()) {
            session.addLap();

            // Toggle resting state
            resting = Properties.getValue("resting");
            if (resting) {
                _plyoData.enableAccel();
                Properties.setValue("resting", false);
                setCount += 1;
            } else {
                _plyoData.disableAccel();
                Properties.setValue("resting", true);
            }

            // Save lap time
            var info = Activity.getActivityInfo();
            if (info != null && info.timerTime != null) {
                timeAtLastLap = info.timerTime; // Mark the split
            }
            WatchUi.requestUpdate();
        }
    }

    public function saveRecording() as Void {
        if (session != null) {
            session.save();
            session = null; // Clean up
            var view = new plyoView();
            WatchUi.switchToView(view, new plyoDelegate(view), WatchUi.SLIDE_RIGHT);
        }
    }

    public function onUpdate(dc) {
        // Clear view
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var info = Activity.getActivityInfo();
        if (info != null && info.timerTime != null) {
            _lapTime = info.timerTime - timeAtLastLap;
        }

        var lapTimeStr = formatTime(_lapTime as Number);
        var lapTimeView = findDrawableById("LapTimerLabel") as WatchUi.Text;
        lapTimeView.setText(lapTimeStr);

        var setCountStr = "";
        if (Properties.getValue("resting") == true) {
            setCountStr = "Next Set: " + (setCount + 1).format("%d"); 
        } else {
            setCountStr = "Current Set: " + (setCount).format("%d"); 
        }
        var setCountView = findDrawableById("SetCounter") as WatchUi.Text;
        setCountView.setText(setCountStr);
        
        View.onUpdate(dc);
    }

    // Helper to format seconds into M:SS or H:MM:SS
    public function formatTime(milliseconds as Number) as String {
        var seconds = (milliseconds / 1000) as Number;
        var hrs = seconds / 3600 as Number;
        var min = (seconds / 60) % 60;
        var sec = seconds % 60;
        
        if (hrs > 0) {
            return hrs.format("%d") + ":" + min.format("%02d") + ":" + sec.format("%02d");
        } else {
            return min.format("%d") + ":" + sec.format("%02d");
        }
    }
}