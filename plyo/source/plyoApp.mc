import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class plyoApp extends Application.AppBase {

    private var _mainView as plyoView?;

    public function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
        if (_mainView != null) {
        }
    }

    // Return the initial view of your application here
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        _mainView = new plyoView();
        return [ _mainView, new plyoDelegate() ];
    }

}

function getApp() as plyoApp {
    return Application.getApp() as plyoApp;
}