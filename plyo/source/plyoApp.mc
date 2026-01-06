import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Properties;

class plyoApp extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        var currentPage = Properties.getValue("currentPage") as Number;
        return [pageToView(currentPage), new plyoDelegate()];
    }
}

function getApp() as plyoApp {
    return Application.getApp() as plyoApp;
}