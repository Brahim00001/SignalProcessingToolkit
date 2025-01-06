function noisySignal = addNoise(signal, noiseType, SNR)
    % addNoise adds noise to a signal with a specified SNR.
    %
    % INPUTS:
    % signal    - Struct containing time vector and signal data
    % noiseType - Type of noise ('gaussian', 'uniform')
    % SNR       - Signal-to-noise ratio in dB
    %
    % OUTPUT:
    % noisySignal - Struct with noisy signal data and time vector

    if ~isstruct(signal) || ~isfield(signal, 'time') || ~isfield(signal, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Signal power
    signalPower = mean(signal.data .^ 2);

    % Generate noise
    switch lower(noiseType)
        case 'gaussian'
            noise = randn(size(signal.data)); % Gaussian noise
        case 'uniform'
            noise = (rand(size(signal.data)) - 0.5) * 2; % Uniform noise
        otherwise
            error('Unsupported noise type: %s', noiseType);
    end

    % Scale noise to achieve desired SNR
    noisePower = mean(noise .^ 2);
    scalingFactor = sqrt(signalPower / (10^(SNR / 10)) / noisePower);
    noise = scalingFactor * noise;

    % Add noise to signal
    noisySignal.time = signal.time;
    noisySignal.data = signal.data + noise;
end

function denoisedSignal = removeNoise(noisySignal, filterType, filterParams)
    % removeNoise applies a filter to remove noise from a signal.
    %
    % INPUTS:
    % noisySignal - Struct containing time vector and noisy signal data
    % filterType  - Type of filter ('lowpass', 'highpass', 'bandpass')
    % filterParams - Struct containing filter parameters:
    %                - cutoff: Cutoff frequency (or [low, high] for bandpass)
    %                - fs: Sampling frequency
    %
    % OUTPUT:
    % denoisedSignal - Struct with filtered signal data and time vector

    if ~isstruct(noisySignal) || ~isfield(noisySignal, 'time') || ~isfield(noisySignal, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Design filter
    fs = filterParams.fs;
    switch lower(filterType)
        case 'lowpass'
            d = designfilt('lowpassiir', 'FilterOrder', 8, ...
                'HalfPowerFrequency', filterParams.cutoff, 'SampleRate', fs);
        case 'highpass'
            d = designfilt('highpassiir', 'FilterOrder', 8, ...
                'HalfPowerFrequency', filterParams.cutoff, 'SampleRate', fs);
        case 'bandpass'
            d = designfilt('bandpassiir', 'FilterOrder', 8, ...
                'HalfPowerFrequency1', filterParams.cutoff(1), ...
                'HalfPowerFrequency2', filterParams.cutoff(2), 'SampleRate', fs);
        otherwise
            error('Unsupported filter type: %s', filterType);
    end

    % Apply filter
    filteredData = filtfilt(d, noisySignal.data);

    % Return filtered signal
    denoisedSignal.time = noisySignal.time;
    denoisedSignal.data = filteredData;
end
