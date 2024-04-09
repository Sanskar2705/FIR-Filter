clc
clear all

fc = 8.4e3; % Cutoff Frequency
fs = 25e3; % Sampling Frequency
Rp = 0.5; % Passband Ripple in dB
Rs = 60; % Stopband Attenuation in dB

% Elliptic filter
[b, a] = ellip(4, Rp, Rs, fc/(fs/2), 'low');

impulse_signal = [1, zeros(1, 99)];

% Filter impulse signal using IIR filter
IIR_ImpulseResponse = filter(b, a, impulse_signal);
FIR = IIR_ImpulseResponse(1:13);

% Loading audio 
[audio,Fs] = audioread('song.mp3');
audio = resample(audio,fs,Fs);
audio = audio(:,1);
audio = audio(1:250001);

% Perform FFT on original audio
fft_result = fft(audio);
len = length(audio);
frequencies = linspace(0, fs, len);
magnitude_dB = 20*log10(abs(fft_result));

% Plot original audio spectrum
figure;
subplot(3,1,1)
plot(frequencies, magnitude_dB);
title('Original Audio Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;
xlim([0, fs/2]);

% Filter audio using designed FIR filter
audio_filtered = filter(FIR,1,audio);

% Perform FFT on filtered audio
fft_result_1 = fft(audio_filtered);
len = length(audio_filtered);
frequencies = linspace(0, fs, len);
magnitude_dB = 20*log10(abs(fft_result_1));

% subplot(3,1,2)
% plot(frequencies, magnitude_dB);
% title('Filtered Audio Spectrum');
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');
% grid on;
% xlim([0, fs/2]);

% Convert FIR coefficients to fixed-point for usage in Simulink
fir_fi = fi(FIR,1,8,6);
ts = 1/fs;
time = ts * (0:length(audio) - 1);
for i = 1:13
    simin{i} = timeseries(fir_fi(i),time);
end

% Load Simulink output
load('SimulinkOut.mat')
audio_filtered_sim = get(out,"simout");
audio_filtered_sim1 = audio_filtered_sim.Data(:,1);
audio_filtered_sim1 = audio_filtered_sim1.data;

% Perform FFT on Simulink filtered audio
fft_result_2 = fft(audio_filtered_sim1);
len = length(audio_filtered_sim1);
frequencies = linspace(0, fs, len);
magnitude_dB = 20*log10(abs(fft_result_2));

% Plot filtered Simulink audio spectrum
% subplot(3,1,3)
% plot(frequencies, magnitude_dB);
% title('Filtered Simulink Audio Spectrum');  
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');
% grid on;
% xlim([0, fs/2]);

% Calculate Mean Squared Error (MSE) between designed and Simulink filtered audio
mse = 0.5.*(abs(Y1 - Y2).^2);
data = mse;

% Define window size for moving average
windowSize = 700;

% Calculate moving average of MSE
movingAvg = conv(data, ones(1, windowSize) / windowSize, 'valid');

% Plot MSE and its moving average
figure;
plot(frequencies, data, 'DisplayName', 'Instantaneous MSE');
hold on;
plot(frequencies(windowSize:end), movingAvg, 'r', 'DisplayName', ['Moving Average (', num2str(windowSize), ' samples)']);
hold off;
title('Mean Squared Error (MSE) between designed and Simulink FIR Filter');
xlabel('Frequency (Hz)');
ylabel('MSE');
xlim([0, fs/2]);
