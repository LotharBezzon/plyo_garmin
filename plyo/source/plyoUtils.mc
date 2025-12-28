import Toybox.Math;
import Toybox.Lang;

/*
    plyoUtils module
    Contains utility classes for signal processing such as FFT and Auto-correlation.
*/

class SimpleFFT {
    
    // Performs FFT in-place. 
    // input: Array of Numbers (Real values i.e., your manhattan norms)
    // returns: Array of Numbers (Magnitudes representing power at each frequency)
    function computeMagnitude(input) {
        var n = input.size();
        var m = 0; // m = log2(n)
        
        // 1. Calculate m and ensure n is a power of 2
        var temp = n;
        while (temp > 1) {
            if (temp % 2 != 0) { return null; } // Error: Size must be power of 2
            temp = temp >> 1;
            m++;
        }

        // 2. Separate Real and Imaginary parts
        // copying input to 'rex' (real) and creating empty 'imx' (imaginary)
        var rex = new [n];
        var imx = new [n];
        for (var i = 0; i < n; i++) {
            rex[i] = input[i].toFloat(); // Use Float for precision
            imx[i] = 0.0f;
        }

        // 3. Bit Reversal Permutation
        var j = 0;
        for (var i = 0; i < n - 1; i++) {
            if (i < j) {
                var tr = rex[i]; rex[i] = rex[j]; rex[j] = tr;
                var ti = imx[i]; imx[i] = imx[j]; imx[j] = ti;
            }
            var k = n / 2;
            while (k <= j) {
                j = j - k;
                k = k / 2;
            }
            j = j + k;
        }

        // 4. The FFT Butterfly Computation
        for (var l = 1; l <= m; l++) {
            var le = 1 << l;       // 2^l
            var le2 = le >> 1;     // le / 2
            var ur = 1.0f;
            var ui = 0.0f;
            // Calculate Sine/Cosine once per level to save CPU
            var sr = Math.cos(Math.PI / le2); 
            var si = -Math.sin(Math.PI / le2);

            for (var j2 = 0; j2 < le2; j2++) {
                for (var i = j2; i < n; i += le) {
                    var ip = i + le2;
                    var tr = rex[ip] * ur - imx[ip] * ui;
                    var ti = rex[ip] * ui + imx[ip] * ur;
                    rex[ip] = rex[i] - tr;
                    imx[ip] = imx[i] - ti;
                    rex[i] = rex[i] + tr;
                    imx[i] = imx[i] + ti;
                }
                var tr = ur;
                ur = tr * sr - ui * si;
                ui = tr * si + ui * sr;
            }
        }

        // 5. Calculate Magnitude (Sqrt(Re^2 + Im^2))
        // We only return the first n/2 bins (Nyquist limit)
        var magnitudes = new [n / 2];
        for (var i = 0; i < n / 2; i++) {
            magnitudes[i] = Math.sqrt(rex[i] * rex[i] + imx[i] * imx[i]);
        }
        
        return magnitudes;
    }
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