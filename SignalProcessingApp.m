function SignalProcessApp
    % Create Main Figure
    hFig = figure('Name', 'Signal Processing Toolkit', ...
                  'NumberTitle', 'off', ...
                  'Position', [100, 100, 1200, 800], ...
                  'MenuBar', 'none', ...
                  'Resize', 'off', ...
                  'Color', [0.94, 0.94, 0.96]);

    % Create a Tab Group
    hTabGroup = uitabgroup(hFig, 'Position', [0.01, 0.15, 0.98, 0.8]);

    % Add Tabs
    hTabSignalGen = uitab(hTabGroup, 'Title', 'Signal Generation');
    hTabFiltering = uitab(hTabGroup, 'Title', 'Filtering');
    hTabNoise = uitab(hTabGroup, 'Title', 'Noise Removal');
    hTabModulation = uitab(hTabGroup, 'Title', 'Modulation');
    hTabFourier = uitab(hTabGroup, 'Title', 'Fourier Analysis');
    hTabSpectrogram = uitab(hTabGroup, 'Title', 'Spectrogram');

    % Add Panels and Axes to Each Tab
    createSignalGenTab(hTabSignalGen);
    createFilteringTab(hTabFiltering);
    createNoiseTab(hTabNoise);
    createModulationTab(hTabModulation);
    createFourierTab(hTabFourier);
    createSpectrogramTab(hTabSpectrogram);

    % Add a Stylish Header
    uicontrol(hFig, 'Style', 'text', ...
              'String', 'Signal Processing Toolkit', ...
              'FontSize', 18, ...
              'FontWeight', 'bold', ...
              'ForegroundColor', [0, 0.447, 0.741], ...
              'BackgroundColor', [0.94, 0.94, 0.96], ...
              'Position', [350, 720, 500, 50], ...
              'HorizontalAlignment', 'center');

    % Add Footer
    uicontrol(hFig, 'Style', 'text', ...
              'String', '© 2025 Signal Process Toolkit - All Rights Reserved', ...
              'FontSize', 10, ...
              'ForegroundColor', [0.5, 0.5, 0.5], ...
              'BackgroundColor', [0.94, 0.94, 0.96], ...
              'Position', [400, 10, 400, 20], ...
              'HorizontalAlignment', 'center');

    %% Nested Functions for Tabs
    function createSignalGenTab(tab)
        ax = axes('Parent', tab, 'Position', [0.1, 0.4, 0.8, 0.5]);
        title(ax, 'Generated Signal');
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Amplitude');
        grid(ax, 'on');

        uicontrol(tab, 'Style', 'text', 'String', 'Frequency (Hz):', ...
                  'Position', [100, 100, 150, 25], 'HorizontalAlignment', 'left');
        freqEdit = uicontrol(tab, 'Style', 'edit', 'String', '10', ...
                             'Position', [250, 100, 100, 25]);

        uicontrol(tab, 'Style', 'pushbutton', 'String', 'Generate Signal', ...
                  'Position', [400, 100, 150, 30], ...
                  'Callback', @(~, ~) generateSignal(ax, str2double(freqEdit.String)));

        function generateSignal(ax, freq)
            if isnan(freq) || freq <= 0
                errordlg('Invalid frequency value!', 'Error');
                return;
            end
            fs = 1000;
            t = 0:1/fs:2;
            signal = sin(2 * pi * freq * t);
            plot(ax, t, signal, 'b');
            title(ax, ['Generated Signal (Frequency = ', num2str(freq), ' Hz)']);
            xlabel(ax, 'Time (s)');
            ylabel(ax, 'Amplitude');
            grid(ax, 'on');
        end
    end

    function createFilteringTab(tab)
        ax = axes('Parent', tab, 'Position', [0.1, 0.4, 0.8, 0.5]);
        title(ax, 'Filtered Signal');
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Amplitude');
        grid(ax, 'on');

        uicontrol(tab, 'Style', 'text', 'String', 'Cutoff Frequency (Hz):', ...
                  'Position', [100, 100, 150, 25], 'HorizontalAlignment', 'left');
        cutoffEdit = uicontrol(tab, 'Style', 'edit', 'String', '50', ...
                               'Position', [250, 100, 100, 25]);

        uicontrol(tab, 'Style', 'pushbutton', 'String', 'Apply Filter', ...
                  'Position', [400, 100, 150, 30], ...
                  'Callback', @(~, ~) applyFilter(ax, str2double(cutoffEdit.String)));

        function applyFilter(ax, cutoff)
            fs = 1000;
            t = 0:1/fs:2;
            signal = sin(2*pi*20*t) + sin(2*pi*100*t);

            if isnan(cutoff) || cutoff <= 0
                errordlg('Invalid cutoff frequency!', 'Error');
                return;
            end
            [b, a] = butter(4, cutoff / (fs / 2), 'low');
            filteredSignal = filter(b, a, signal);

            plot(ax, t, filteredSignal, 'r');
            title(ax, ['Filtered Signal (Cutoff Frequency = ', num2str(cutoff), ' Hz)']);
            xlabel(ax, 'Time (s)');
            ylabel(ax, 'Amplitude');
            grid(ax, 'on');
        end
    end

    function createNoiseTab(tab)
        ax = axes('Parent', tab, 'Position', [0.1, 0.4, 0.8, 0.5]);
        title(ax, 'Signal with Noise');
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Amplitude');
        grid(ax, 'on');

        uicontrol(tab, 'Style', 'pushbutton', 'String', 'Add Noise', ...
                  'Position', [400, 100, 150, 30], ...
                  'Callback', @(~, ~) addNoise(ax));

        function addNoise(ax)
            fs = 1000;
            t = 0:1/fs:2;
            cleanSignal = sin(2 * pi * 50 * t);
            noise = randn(size(cleanSignal)) * 0.2;
            noisySignal = cleanSignal + noise;

            plot(ax, t, noisySignal, 'g');
            title(ax, 'Signal with Added Noise');
            xlabel(ax, 'Time (s)');
            ylabel(ax, 'Amplitude');
            grid(ax, 'on');
        end
    end

    function createModulationTab(tab)
        ax = axes('Parent', tab, 'Position', [0.1, 0.4, 0.8, 0.5]);
        title(ax, 'Modulated Signal');
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Amplitude');
        grid(ax, 'on');

        uicontrol(tab, 'Style', 'pushbutton', 'String', 'AM Modulation', ...
                  'Position', [400, 100, 150, 30], ...
                  'Callback', @(~, ~) modulateSignal(ax));

        function modulateSignal(ax)
            fs = 1000;
            t = 0:1/fs:2;
            carrier = sin(2 * pi * 100 * t);
            message = sin(2 * pi * 5 * t);
            modulatedSignal = (1 + message) .* carrier;

            plot(ax, t, modulatedSignal, 'm');
            title(ax, 'Amplitude Modulated Signal');
            xlabel(ax, 'Time (s)');
            ylabel(ax, 'Amplitude');
            grid(ax, 'on');
        end
    end

    function createFourierTab(tab)
        ax = axes('Parent', tab, 'Position', [0.1, 0.4, 0.8, 0.5]);
        title(ax, 'Fourier Transform');
        xlabel(ax, 'Frequency (Hz)');
        ylabel(ax, 'Magnitude');
        grid(ax, 'on');

        uicontrol(tab, 'Style', 'pushbutton', 'String', 'Perform Fourier Transform', ...
                  'Position', [400, 100, 200, 30], ...
                  'Callback', @(~, ~) performFourier(ax));

        function performFourier(ax)
            fs = 1000;
            t = 0:1/fs:2;
            signal = sin(2*pi*50*t) + sin(2*pi*120*t);
            N = length(signal);
            f = (0:N-1)*(fs/N);
            Y = abs(fft(signal));

            plot(ax, f(1:N/2), Y(1:N/2), 'k');
            title(ax, 'Fourier Transform');
            xlabel(ax, 'Frequency (Hz)');
            ylabel(ax, 'Magnitude');
            grid(ax, 'on');
        end
    end

    function createSpectrogramTab(tab)
        ax = axes('Parent', tab, 'Position', [0.1, 0.4, 0.8, 0.5]);
        title(ax, 'Spectrogram');
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Frequency (Hz)');
        grid(ax, 'on');

        uicontrol(tab, 'Style', 'pushbutton', 'String', 'Generate Spectrogram', ...
                  'Position', [400, 100, 200, 30], ...
                  'Callback', @(~, ~) generateSpectrogram(ax));

        function generateSpectrogram(ax)
            fs = 1000;
            t = 0:1/fs:2;
            signal = sin(2*pi*50*t) + sin(2*pi*120*t);

            spectrogram(signal, 256, 200, 256, fs, 'yaxis');
            colormap('jet');
            title(ax, 'Spectrogram');
        end
    end
end
