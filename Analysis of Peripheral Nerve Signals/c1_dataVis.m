clear all
close all
clc

%% Import Data
load('data.mat');
fs=20000;
%% Example: Plot the raw signal
% signal=Pinch.signal;
% labels=Pinch.trigger;
% TRIG = gettrigger(labels,0.5); % if over 0.5 put in to trigger
% TRIGend = gettrigger(-labels,-0.5); %if labels is over -0.5 then put label end
% 
% % not showing figure plot - uncomment to show
% figure('units','normalized','Position',[0.1,0.1,0.7,0.4]) %figure position set
% plot((1:length(signal))./fs,zscore(signal)); % (x-axis(change to time scale), z-scale(signal)) 
% hold on;
% plot((1:length(signal))./fs,zscore(labels),'y'); %plot labels
% stem(TRIG./fs,ones(length(TRIG),1)*max(zscore(labels)),'Color','g'); %plot green and red for easier look
% stem(TRIGend./fs,ones(length(TRIG),1)*max(zscore(labels)),'Color','r');
% grid on; grid minor;
% xlim([0,length(signal)./fs]) %set x axis limits
% xlabel('Time (s)')
% ylabel('Amplitude (uV)')
% title('Raw Pinch signal with labels for stimulation periods')



%% (my study) Plot smaller scale

% signal=VF.signal;
% signal=signal(1:6000)
% labels=VF.trigger;
% labels=labels(1:6000)
% TRIG = gettrigger(labels,0.5); % if over 0.5 put in to trigger
% TRIGend = gettrigger(-labels,-0.5); %if labels is over -0.5 then put label end
% 
% figure('units','normalized','Position',[0.1,0.1,0.7,0.4]) %figure position set
% plot((1:length(signal))./fs,zscore(signal)); % (x-axis(change to time scale), z-scale(signal)) 
% hold on;
% plot((1:length(signal))./fs,zscore(labels),'y'); %plot labels
% stem(TRIG./fs,ones(length(TRIG),1)*max(zscore(labels)),'Color','g'); %plot green and red for easier look
% stem(TRIGend./fs,ones(length(TRIG),1)*max(zscore(labels)),'Color','r');
% grid on; grid minor;
% xlim([0,length(signal)./fs]) %set x axis limits
% xlabel('Time (s)')
% ylabel('Amplitude (uV)')
% title('Raw VF signal with labels for stimulation periods (300ms)')

%% Example: PSD estimates

signal_vf=VF.signal; 
labels_vf=VF.trigger;

signal_flex=Flex.signal; 
labels_flex=Flex.trigger;

signal_pinch=Pinch.signal; 
labels_pinch=Pinch.trigger;

figure('units','normalized','Position',[0.1,0.1,0.5,0.5]) %need to preced before hold on;

hold on;

[rows_act,cols_act,values_act] = find(labels_vf>0);
[rows_rest1,cols_rest,values_rest] = find(labels_vf==0);
notOfInterest1 = signal_vf(rows_rest1);
signalOfInterest=signal_vf(rows_act);
h = spectrum.welch; % creates the Welch spectrum estimator
SOIf=psd(h,signalOfInterest,'Fs',fs); % calculates and plot the one sided PSD
plot(SOIf); % Plot the one-sided PSD. 

temp =get(gca);
temp.Children(1).Color = 'b';


% figure('units','normalized','Position',[0.1,0.1,0.5,0.5])
[rows_act,cols_act,values_act] = find(labels_flex>0);
[rows_rest1,cols_rest,values_rest] = find(labels_flex==0);
notOfInterest2 = signal_flex(rows_rest1);
signalOfInterest=signal_flex(rows_act);
h = spectrum.welch; % creates the Welch spectrum estimator
SOIf=psd(h,signalOfInterest,'Fs',fs); % calculates and plot the one sided PSD
plot(SOIf); % Plot the one-sided PSD. 

temp =get(gca);
temp.Children(1).Color = 'g';


% figure('units','normalized','Position',[0.1,0.1,0.5,0.5])
[rows_act,cols_act,values_act] = find(labels_pinch>0);
[rows_rest1,cols_rest,values_rest] = find(labels_pinch==0);
notOfInterest3 = signal_pinch(rows_rest1);
signalOfInterest=signal_pinch(rows_act);
h = spectrum.welch; % creates the Welch spectrum estimator
SOIf=psd(h,signalOfInterest,'Fs',fs); % calculates and plot the one sided PSD
plot(SOIf); % Plot the one-sided PSD. 

temp =get(gca);
temp.Children(1).Color = 'r';

%Rest signal
% RestInterst = [notOfInterest1 notOfInterest2 notOfInterest3];
% Rest 신호를 세 개의 신호를 합쳐서 구성 (길이 맞추기)
% min_length = min([length(notOfInterest1), length(notOfInterest2), length(notOfInterest3)]);
% RestInterest = mean([notOfInterest1(1:min_length), notOfInterest2(1:min_length), notOfInterest3(1:min_length)],2);


h = spectrum.welch; % creates the Welch spectrum estimator
SOIf1=psd(h,notOfInterest1,'Fs',fs); % calculates and plot the one sided PSD
SOIf2=psd(h,notOfInterest2,'Fs',fs); % calculates and plot the one sided PSD
SOIf3=psd(h,notOfInterest3,'Fs',fs); % calculates and plot the one sided PSD

meanPSD = (SOIf1.Data+ SOIf2.Data+ SOIf3.Data)./3; % `.‘` 사용하여 transpose
freqs=SOIf3.Frequencies;


% ✅ 새로운 PSD 객체 생성 (dspdata.psd 사용)
SOIf_mean = dspdata.psd(meanPSD, 'Fs', 20000);
plot(SOIf_mean); % 기존 방식과 동일하게 출력
temp =get(gca);
temp.Children(1).Color = 'black';

hold off;
% plot(freqs/1000,meanPSD);
%% Bandpass Filtering - Ctrl + R = comment , Ctrl+t = uncomment

% signal_vf=Flex.signal; 
% labels=Flex.trigger;
% 
% fc1 = 0.8*1000; % first cutoff frequency in Hz  = 0.8kHz
% fc2 = 2.2*1000; % second cutoff frequency in Hz = 2.2 kHz
% 
% % normalize the frequencies
% Wp = [fc1 fc2]*2/fs;
% 
% % Build a Butterworth bandpass filter of 4th order
% % check the "butter" function in matlab
% [b,a] = butter(4,Wp);
% filteredSignal_vf=filter(b,a,signal_vf);
% % Filter data of both classes with a non-causal filter
% % Hint: use "filtfilt" function in MATLAB
% filteredSignal_filt = filtfilt(b,a,filteredSignal_vf);



%% 
% 
% signal=VF.signal;
% labels=VF.trigger;
% 
% TRIG = gettrigger(labels,0.5); % if over 0.5 put in to trigger
% TRIGend = gettrigger(-labels,-0.5); %if labels is over -0.5 then put label end
% 
% figure('units','normalized','Position',[0.1,0.1,0.7,0.4]) %figure position set
% plot((1:length(signal))./fs,zscore(signal)); % (x-axis(change to time scale), z-scale(signal)) 
% hold on;
% 
% % 
% plot((1:length(filteredSignal))./fs,zscore(filteredSignal)); % (x-axis(change to time scale), z-scale(signal)) 
% 
% plot((1:length(signal))./fs,zscore(labels),'y'); %plot labels
% stem(TRIG./fs,ones(length(TRIG),1)*max(zscore(labels)),'Color','g'); %plot green and red for easier look
% stem(TRIGend./fs,ones(length(TRIG),1)*max(zscore(labels)),'Color','r');
% grid on; grid minor;
% xlim([0,length(signal)./fs]) %set x axis limits
% xlabel('Time (s)')
% ylabel('Amplitude (uV)')
% title('Raw VF signal Before Band Pass Filering')


%% After filtering, before filtering VF signal PSD comparison

% 
% signal_vf=VF.signal; 
% labels_vf=VF.trigger;
% 
% figure('units','normalized','Position',[0.1,0.1,0.5,0.5]) %need to preced before hold on;
% 
% hold on;
% 
% [rows_act,cols_act,values_act] = find(labels_vf>0);
% [rows_rest1,cols_rest,values_rest] = find(labels_vf==0);
% notOfInterest = signal_vf(rows_rest1);
% signalOfInterest=signal_vf(rows_act);
% h = spectrum.welch; % creates the Welch spectrum estimator
% SOIf=psd(h,signalOfInterest,'Fs',fs); % calculates and plot the one sided PSD
% plot(SOIf); % Plot the one-sided PSD. 
% 
% temp =get(gca);
% temp.Children(1).Color = 'b';
% 
% [rows_act,cols_act,values_act] = find(labels_vf>0);
% [rows_rest1,cols_rest,values_rest] = find(labels_vf==0);
% notOfInterest = filteredSignal(rows_rest1);
% signalOfInterest=filteredSignal(rows_act);
% h = spectrum.welch; % creates the Welch spectrum estimator
% SOIf=psd(h,signalOfInterest,'Fs',fs); % calculates and plot the one sided PSD
% plot(SOIf); % Plot the one-sided PSD. 
% 
% temp =get(gca);
% temp.Children(1).Color = 'r';