clear all
close all
clc

%% Import Data 
load('data.mat');
fs=20000;

signal_vf=VF.signal; 
labels_vf=VF.trigger;

signal_pinch=Pinch.signal; 
labels_pinch=Pinch.trigger;

signal_flex=Flex.signal; 
labels_flex=Flex.trigger;

fc1 = 0.8*1000; % first cutoff frequency in Hz  = 0.8kHz
fc2 = 2.2*1000; % second cutoff frequency in Hz = 2.2 kHz

% normalize the frequencies
Wp = [fc1 fc2]*2/fs;

% Build a Butterworth bandpass filter of 4th order
% check the "butter" function in matlab
[b,a] = butter(4,Wp);
filteredSignal_vf=filter(b,a,signal_vf);
filteredSignal_pinch=filter(b,a,signal_pinch);
filteredSignal_flex=filter(b,a,signal_flex);
% Filter data of both classes with a non-causal filter
% Hint: use "filtfilt" function in MATLAB
vf_filteredSignal_filt = filtfilt(b,a,filteredSignal_vf);
pinch_filteredSignal_filt = filtfilt(b,a,filteredSignal_pinch);
flex_filteredSignal_filt = filtfilt(b,a,filteredSignal_flex);

%% change here to change data
filteredSignal = flex_filteredSignal_filt; % bandapass filtered signal 
label = labels_flex; % labels of stimulus locations

% WSize = 0.3; % window size in s 0.05(50ms), 0.1(100ms), 0.3(300ms)
% Olap = 0; % overlap percentage (0, 0.25, 0.75)

% WSizeSec_list = [0.05, 0.1, 0.3];  % in seconds (50ms, 100ms, 300ms)
% Olap_list= [0, 0.25, 0.75]; % overlap ratios

WSizeSec_list = [0.1];  % in seconds (50ms, 100ms, 300ms)
Olap_list = [0]; % overlap ratios

%% Extracting Features over overlapping windows


Rise1 = gettrigger(label,0.5); % gets the starting points of stimulations
Fall1 = gettrigger(-label,-0.5); % gets the ending points of stimulation
subIndex=1;
for i = 1:length(WSizeSec_list)
    
    for j = 1:length(Olap_list)
        
        WSize_sec=WSizeSec_list(i);
        Olap=Olap_list(j);
        WSize = floor(WSize_sec*fs);	    % length of each data frame, datapoints
        nOlap = floor(Olap*WSize);  % overlap of successive frames, half of WSize
        hop = WSize-nOlap;	    % amount to advance for next data frame
        nx = length(filteredSignal);	            % length of input vector
        len = fix((nx - (WSize-hop))/hop);	%length of output vector = total frames

        % preallocate outputs for speed - VF
        [MAV_feature, VAR_feature, featureLabels] = deal(zeros(1,len));
        
        
        %% Plotting the features
        % Note: when plotting the features, scale the featureLabels to the max of
        % the feature values for proper visualization

        
        for frameIdx=1:len
            startIdx=(frameIdx-1)*hop+1;
            endIdx=(frameIdx-1)*hop+WSize;
            
            segment = filteredSignal(startIdx:endIdx);
            MAV_feature(frameIdx) = mean(abs(segment)) ;
            VAR_feature(frameIdx) = var(segment,1); %normalize by 1/N
        
            % re-build the label vector to match it with the feature vector
            % featureLabels(i) = sum(arrayfun(@(t) ((i-1)*hop+1) >= Rise1(t) && ((i-1)*hop+WSize) <= Fall1(t), 1:length(Rise1)));
            featureLabels(frameIdx) = sum(arrayfun(@(t) ...
                (startIdx >= Rise1(t)) && (endIdx <= Fall1(t)), ...
                1:length(Rise1)));
        end
           

    end

end


%% save mat features in computer
% 
% save('saveA.mat','A');
% example = matfile('saveA.mat');
% C = example.A;

% save('VF_feature_mav',"MAV_feature");
% save('VF_feature_var',"VAR_feature");
% save('VF_feature_label',"featureLabels")

% save('Pinch_feature_mav',"MAV_feature");
% save('Pinch_feature_var',"VAR_feature");
% save('Pinch_feature_label',"featureLabels")

% save('Flex_feature_mav',"MAV_feature");
% save('Flex_feature_var',"VAR_feature");
% save('Flex_feature_label',"featureLabels")
