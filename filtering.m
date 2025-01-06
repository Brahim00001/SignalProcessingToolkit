function filteredSignal = applyFilter(signal, filterType, cutoffFreq, fs)
    % applyFilter applies a specified filter to the input signal.
    %
    % INPUTS:
    % signal     - Struct containing time vector and signal data
    % filterType - Type of filter: 'lowpass', 'highpass', 'bandpass', 'bandstop'
    % cutoffFreq - Cutoff frequency/frequencies (Hz)
    % fs         - Sampling frequency (Hz)
    %
    % OUTPUT:
    % filteredSignal - Struct with filtered data and time vector

    % Validate inputs
    if ~isstruct(signal) || ~isfield(signal, 'time') || ~isfield(signal, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end
    
    if nargin < 4
        error('Not enough input arguments. Provide signal, filterType, cutoffFreq, and fs.');
    end

    % Design the filter based on filterType
    switch lower(filterType)
        case 'lowpass'
            d = designfilt('lowpassiir', 'FilterOrder', 8, ...
                           'HalfPowerFrequency', cutoffFreq / (fs / 2), ...
                           'DesignMethod', 'butter');
        case 'highpass'
            d = designfilt('highpassiir', 'FilterOrder', 8, ...
                           'HalfPowerFrequency', cutoffFreq / (fs / 2), ...
                           'DesignMethod', 'butter');
        case 'bandpass'
            if numel(cutoffFreq) ~= 2
                error('Bandpass filter requires a two-element vector for cutoff frequencies.');
            end
            d = designfilt('bandpassiir', 'FilterOrder', 8, ...
                           'HalfPowerFrequency1', cutoffFreq(1) / (fs / 2), ...
                           'HalfPowerFrequency2', cutoffFreq(2) / (fs / 2), ...
                           'DesignMethod', 'butter');
        case 'bandstop'
            if numel(cutoffFreq) ~= 2
                error('Bandstop filter requires a two-element vector for cutoff frequencies.');
            end
            d = designfilt('bandstopiir', 'FilterOrder', 8, ...
                           'HalfPowerFrequency1', cutoffFreq(1) / (fs / 2), ...
                           'HalfPowerFrequency2', cutoffFreq(2) / (fs / 2), ...
                           'DesignMethod', 'butter');
        otherwise
            error('Invalid filter type. Choose ''lowpass'', ''highpass'', ''bandpass'', or ''bandstop''.');
    end

    % Apply the filter using filtfilt for zero-phase distortion
    filteredData = filtfilt(d, signal.data);

    % Output the filtered signal
    filteredSignal.time = signal.time;
    filteredSignal.data = filteredData;
end
