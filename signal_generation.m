function signal = generateSignal(signalType, amplitude, frequency, duration, phase)
    % generateSignal generates various types of signals based on input parameters.
    %
    % INPUTS:
    % signalType - Type of signal: 'sine', 'square', 'composite'
    % amplitude  - Amplitude of the signal
    % frequency  - Frequency of the signal in Hz
    % duration   - Duration of the signal in seconds (default: 1)
    % phase      - Phase offset in radians (default: 0)
    %
    % OUTPUT:
    % signal - Struct containing time vector and signal data
    
    % Default values for optional parameters
    if nargin < 4
        duration = 1; % Default duration of 1 second
    end
    if nargin < 5
        phase = 0; % Default phase of 0 radians
    end

    % Sampling rate (higher values give smoother signals)
    fs = 1000; % Sampling frequency in Hz
    t = 0:1/fs:duration; % Time vector

    % Generate the signal based on type
    switch lower(signalType)
        case 'sine'
            data = amplitude * sin(2 * pi * frequency * t + phase);
            
        case 'square'
            data = amplitude * square(2 * pi * frequency * t + phase);
            
        case 'composite'
            % Example composite signal: combination of two sine waves
            data = amplitude * (sin(2 * pi * frequency * t + phase) + ...
                                0.5 * sin(2 * pi * (frequency * 2) * t));
            
        otherwise
            error('Invalid signal type. Choose ''sine'', ''square'', or ''composite''.');
    end

    % Output the signal as a struct
    signal.time = t;
    signal.data = data;
end
