clc;
close all;
iir_order= 4;
fir_order= 12;
Fs = 40e3;
Fc = 12.8e3;
Fn = Fc/(Fs/2);
Ap = 0.05; Ap_dB = -20*log(1-Ap);
As = 0.1; As_dB = -20*log(As);
[B,A] = ellip(iir_order,Ap_dB,As_dB,Fn,"low");
imp_signal=[1 zeros(1,5000)];

iir_=filter(B,A,imp_signal);
fir_=iir_(1:fir_order);
fir_fi = fi(fir_,1,8,6);

%audio input
audio_data=audioread("C:\Users\91798\Documents\MATLAB\sample2.mp3");
audio_data=audio_data(:,1);
filter_out = filter(fir_fi,1,fi(audio_data,1,8,6));
fvtool(double(filter_out));
hold on;

fs =40e3;
ts = 1/fs;
samples = 5000;
% Create time vector
time = ts*(0:(samples-1));
time = time';
impulse = [1 zeros(1,samples-1)];
audio_data=audio_data(1:5000);
simin18 = timeseries(fi(audio_data,1,8,6),time);

simin0 = timeseries(fir_fi(1),time);
simin1 = timeseries(fir_fi(2),time);
simin2 = timeseries(fir_fi(3),time);
simin3 = timeseries(fir_fi(4),time);
simin4 = timeseries(fir_fi(5),time);
 simin5 = timeseries(fir_fi(6),time);
 simin6 = timeseries(fir_fi(7),time);
 simin7 = timeseries(fir_fi(8),time);
 simin8 = timeseries(fir_fi(9),time);
 simin9 = timeseries(fir_fi(10),time);
 simin10 = timeseries(fir_fi(11),time);
 simin11 = timeseries(fir_fi(12),time);
% simin12 = timeseries(fir_fi(13),time);
% simin13 = timeseries(fir_fi(14),time);
% simin14 = timeseries(fir_fi(15),time);
% simin15 = timeseries(fir_fi(16),time);
% simin16 = timeseries(fir_fi(17),time);
% simin17 = timeseries(fir_fi(18),time);
