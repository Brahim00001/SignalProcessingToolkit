function generateSpectrogram(signal, fs, windowSize, overlap, nfft)
    % generateSpectrogram computes and plots the spectrogram of a signal.
    %
    % INPUTS:
    % signal     - Struct containing time vector and signal data
    % fs         - Sampling frequency (Hz)
    % windowSize - Size of the sliding window (samples)
    % overlap    - Number of overlapping samples
    % nfft       - Number of FFT points
    %
    % OUTPUT:
    % Displays the spectrogram in a new figure.

    if ~isstruct(signal) || ~isfield(signal, 'time') || ~isfield(signal, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Compute spectrogram
    figure;
    spectrogram(signal.data, windowSize, overlap, nfft, fs, 'yaxis');
    title('Spectrogram');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    colorbar;
end

function powerSpectrum = computePowerSpectrum(signal, fs)
    % computePowerSpectrum computes the power spectral density of a signal.
    %
    % INPUTS:
    % signal - Struct containing time vector and signal data
    % fs     - Sampling frequency (Hz)
    %
    % OUTPUT:
    % powerSpectrum - Struct with frequency and power density arrays
    % Displays a plot of the power spectral density.

    if ~isstruct(signal) || ~isfield(signal, 'time') || ~isfield(signal, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Compute FFT
    n = length(signal.data);
    fftData = fft(signal.data);
    powerDensity = abs(fftData(1:floor(n/2))).^2 / n;
    freq = (0:floor(n/2)-1) * (fs / n);

    % Plot Power Spectrum
    figure;
    plot(freq, 10 * log10(powerDensity));
    title('Power Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    grid on;

    % Return results as struct
    powerSpectrum.frequency = freq;
    powerSpectrum.powerDensity = powerDensity;
end
