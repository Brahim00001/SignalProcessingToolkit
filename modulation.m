function modulatedSignal = amplitudeModulate(baseband, carrierFreq, fs, modulationIndex)
    % amplitudeModulate performs amplitude modulation (AM) on a signal.
    %
    % INPUTS:
    % baseband       - Struct containing time vector and signal data
    % carrierFreq    - Frequency of the carrier signal (Hz)
    % fs             - Sampling frequency (Hz)
    % modulationIndex - Modulation index (0 to 1)
    %
    % OUTPUT:
    % modulatedSignal - Struct with modulated signal data and time vector

    if ~isstruct(baseband) || ~isfield(baseband, 'time') || ~isfield(baseband, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Generate carrier signal
    carrier = cos(2 * pi * carrierFreq * baseband.time);

    % Perform AM modulation
    modulatedData = (1 + modulationIndex * baseband.data) .* carrier;

    % Return modulated signal
    modulatedSignal.time = baseband.time;
    modulatedSignal.data = modulatedData;
end

function modulatedSignal = frequencyModulate(baseband, carrierFreq, fs, freqDev)
    % frequencyModulate performs frequency modulation (FM) on a signal.
    %
    % INPUTS:
    % baseband    - Struct containing time vector and signal data
    % carrierFreq - Frequency of the carrier signal (Hz)
    % fs          - Sampling frequency (Hz)
    % freqDev     - Frequency deviation (Hz)
    %
    % OUTPUT:
    % modulatedSignal - Struct with modulated signal data and time vector

    if ~isstruct(baseband) || ~isfield(baseband, 'time') || ~isfield(baseband, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Compute FM modulation
    phase = 2 * pi * carrierFreq * baseband.time + 2 * pi * freqDev * cumsum(baseband.data) / fs;
    modulatedData = cos(phase);

    % Return modulated signal
    modulatedSignal.time = baseband.time;
    modulatedSignal.data = modulatedData;
end

function demodulatedSignal = amplitudeDemodulate(modulated, carrierFreq, fs)
    % amplitudeDemodulate recovers the baseband signal from an AM signal.
    %
    % INPUTS:
    % modulated    - Struct containing time vector and modulated signal data
    % carrierFreq  - Frequency of the carrier signal (Hz)
    % fs           - Sampling frequency (Hz)
    %
    % OUTPUT:
    % demodulatedSignal - Struct with recovered signal data and time vector

    if ~isstruct(modulated) || ~isfield(modulated, 'time') || ~isfield(modulated, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Generate carrier signal
    carrier = cos(2 * pi * carrierFreq * modulated.time);

    % Perform demodulation by multiplying with carrier
    product = modulated.data .* carrier;

    % Low-pass filter to recover baseband signal
    d = designfilt('lowpassiir', 'FilterOrder', 8, 'HalfPowerFrequency', carrierFreq / 2, 'SampleRate', fs);
    demodulatedData = filtfilt(d, product);

    % Return demodulated signal
    demodulatedSignal.time = modulated.time;
    demodulatedSignal.data = demodulatedData;
end
