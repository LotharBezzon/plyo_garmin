import Toybox.Sensor;
import Toybox.FitContributor;
import Toybox.System;
import Toybox.Lang;
import Toybox.Math;
using plyoUtils;

class plyoData {
    private var _accx = null;
    private var _accy = null;
    private var _accz = null;

    private var _mode as String;

    public function initialize(mode as String) {
        _mode = mode;
    }

    public function enableAccel() as Void {
        var period = 1; // seconds
        var maxSampleRate = 25; // Hz
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
            case "SPEED_POGO":
                // Look for the frequency of jumps. Compute the
                // manhattan norm of the accelerometer data and
                // find the peak in the FFT spectrum.
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

                var autoCorr = new autoCorrelation();
                manhattan = autoCorr.compute(manhattan);

                System.println(manhattan);

                break;
            default:
                break;
        }
    }

}