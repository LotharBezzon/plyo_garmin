import Toybox.Sensor;
import Toybox.FitContributor;
import Toybox.System;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Application.Properties;
import Toybox.WatchUi;

/*
    plyoData class
    Handles accelerometer data collection and processing for plyometric exercises.
*/

class plyoData {
    private var _accx = null;
    private var _accy = null;
    private var _accz = null;

    var period = 1; // seconds
    var maxSampleRate = 25; // Hz

    private var _mode as String = Properties.getValue("mode");

    public function enableAccel() as Void {

        if (Sensor has :getMaxSampleRate) {
            maxSampleRate = Sensor.getMaxSampleRate();
        }
        System.println("Max Accelerometer Sample Rate: " + maxSampleRate);

         // initialize accelerometer to request the maximum amount of data possible
        var options = {
            :period => period,
            :accelerometer => {
                :enabled => true,
                :sampleRate => maxSampleRate
            }
        };
        try {
            Sensor.registerSensorDataListener(method(:accelCallback), options);
        }
        catch(e) {
            System.println(e.getErrorMessage());
        }
    }

    public function disableAccel() as Void {
        Sensor.unregisterSensorDataListener();
    }

    public function accelCallback(data as Sensor.SensorData) as Void {
        _accx = data.accelerometerData.x;
        _accy = data.accelerometerData.y;
        _accz = data.accelerometerData.z;

        switch (_mode) {
            case WatchUi.loadResource(Rez.Strings.menu_label_1): // Speed pogos
                // Look for the frequency of jumps. Compute the
                // manhattan norm of the accelerometer data and
                // find the peak in the autocorrelation.
                var size = _accx.size();
                var manhattan = [];
                var i, x, y, z; // preallocate loop variables
                for (i = 0; i < size; i += 1) {
                    x = _accx[i];
                    y = _accy[i];
                    z = _accz[i];

                    if (x < 0) { x = -x; }
                    if (y < 0) { y = -y; }
                    if (z < 0) { z = -z; }
                    manhattan.add(x + y + z);
                }

                var autoCorr = new autoCorrelation(1, 50);
                var corrs = autoCorr.compute(manhattan);

                var peak = max(corrs);
                System.println(peak);
                var peakFrequency = maxSampleRate / peak[1].toFloat();

                //System.println("corrs: " + corrs);

                //System.println("Peak Frequency: " + peakFrequency + " Hz");

                break;
            default:
                break;
        }
    }

}