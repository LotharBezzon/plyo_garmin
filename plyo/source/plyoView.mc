import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.ActivityRecording;

class plyoView extends WatchUi.View {

    private var _session as Session?;
    private var _plyoData as plyoData?;

    public function initialize() {
        View.initialize();
        _plyoData = new plyoData("SPEED_POGO");
    }

    public function isSessionRecording(){
        return (_session != null) && _session.isRecording();
    }

    public function startRecording() as Void {
        if (_session == null) {
            _session = ActivityRecording.createSession({:name=>"Plyo Session", :sport=>Activity.SPORT_GENERIC});
        }
        _session.start();
        _plyoData.enableAccel();
        WatchUi.requestUpdate();
    }

    public function stopRecording() as Void {
        if (isSessionRecording() && (_session != null)) {
            _session.stop();
            _plyoData.disableAccel();
            WatchUi.requestUpdate();
        }
    }

    public function saveRecording() as Void {
        if (_session != null) {
            _session.save();
            _session = null;
            WatchUi.requestUpdate();
        }
    }

    // Load your resources here
    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    public function onShow() as Void {
    }

    // Update the view
    public function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    public function onHide() as Void {
    }

}
