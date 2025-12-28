import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application.Properties;

class plyoMenuDelegate extends WatchUi.MenuInputDelegate {

    var mode as String?;

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            mode = WatchUi.loadResource(Rez.Strings.menu_label_1);
        } else if (item == :item_2) {
            mode = WatchUi.loadResource(Rez.Strings.menu_label_2);
        } else if (item == :item_3) {
            mode = WatchUi.loadResource(Rez.Strings.menu_label_3);
        } else if (item == :item_4) {
            mode = WatchUi.loadResource(Rez.Strings.menu_label_4);
        }
        Properties.setValue("mode", mode);
        System.println("Selected mode " + Properties.getValue("mode"));    
    }

}