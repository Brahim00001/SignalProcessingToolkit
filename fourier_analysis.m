function frequencyData = performFFT(signal, fs)
    % performFFT computes the FFT of a signal and returns frequency-domain data.
    %
    % INPUTS:
    % signal - Struct containing time vector and signal data
    % fs     - Sampling frequency (Hz)
    %
    % OUTPUT:
    % frequencyData - Struct with fields:
    %                 - frequency: Frequency vector (Hz)
    %                 - magnitude: Single-sided amplitude spectrum

    % Validate inputs
    if ~isstruct(signal) || ~isfield(signal, 'time') || ~isfield(signal, 'data')
        error('Input signal must be a struct with fields "time" and "data".');
    end

    % Signal length and FFT computation
    L = length(signal.data);      % Length of the signal
    Y = fft(signal.data);         % Compute the FFT
    P2 = abs(Y / L);              % Two-sided spectrum
    P1 = P2(1:floor(L/2) + 1);    % Single-sided spectrum
    P1(2:end-1) = 2 * P1(2:end-1); % Scale non-DC components

    % Frequency vector
    f = fs * (0:floor(L/2)) / L;

    % Store frequency data in output struct
    frequencyData.frequency = f;
    frequencyData.magnitude = P1;
end
