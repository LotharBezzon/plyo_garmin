import Toybox.Math;
import Toybox.Lang;

/*
    plyoUtils module
    Contains utility classes for signal processing such as FFT and Auto-correlation.
*/

function max(arr as Array) {
    var maximum = [0, null];
    for (var i = 0; i < arr.size(); i++) {
        if (arr[i] != null) {
                if (arr[i] > maximum[0]) {
                maximum = [arr[i], i];
            }
        }   
    }
    return maximum;
}

class autoCorrelation {

    private var _minLag as Number = 1;
    private var _maxLag as Number = 500;

    public function initialize(minLag as Number, maxLag as Number) {
        _minLag = minLag;
        _maxLag = maxLag;
    }

    public function compute(input) {
        var n = input.size();
        var result = new [n];

        var mean = 0.0;
        for (var i = 0; i < n; i++) {
            mean += input[i];
        }
        mean /= n;
        // Subtract mean
        for (var i = 0; i < n; i++) {
            input[i] -= mean;
        }

        if (_maxLag != null) {
            if (_maxLag > n) {
                _maxLag = n;
            }
        }
        
        for (var lag = _minLag; lag < _maxLag; lag++) {
            var sum = 0.0;
            for (var i = 0; i < n - lag; i++) {
                sum += input[i] * input[i + lag];
            }
            result[lag] = sum / (n - lag);
        }
        
        return result;
    }
    
}