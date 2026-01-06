import Toybox.WatchUi;
import Toybox.Graphics;

class plyoView4 extends WatchUi.View {

    public function initialize() {
        View.initialize();
    }

    // Load your resources here
    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.Main4Layout(dc));
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