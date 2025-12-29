import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.Lang;
import Toybox.Application.Properties;

class plyoView extends WatchUi.View {

    private var _maxNumPages as Number = 5;

    public function initialize() {
        View.initialize();
    }

    public function nextPage() as Void {
        var currentPage = Properties.getValue("currentPage") as Number;
        currentPage = (currentPage + 1) % _maxNumPages;
        Properties.setValue("currentPage", currentPage);
        WatchUi.requestUpdate();
    }

    public function previousPage() as Void {
        var currentPage = Properties.getValue("currentPage") as Number;
        currentPage = (currentPage - 1 + _maxNumPages) % _maxNumPages;
        Properties.setValue("currentPage", currentPage);
        WatchUi.requestUpdate();
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
