
close all; clc;

%%Discriminability of Features
% subj1_data=load('subj1.mat');
subj1_data=load('subj1.mat');
function [subj_left_features , subj_right_features] = calcSessionFeat(session,subj_data)
    subj_left_features = createArray(30,14,32);  % [trial, freq_bin, channel]
    subj_right_features = createArray(30,14,32);
    l_count = 1;
    r_count = 1;
    s = session;

    for j = 1:3 % 3 runs per session
        hyp = subj_data.subj1.online(s).run(j).header.triggers.TYP;
        pos = subj_data.subj1.online(s).run(j).header.triggers.POS;
        eeg = subj_data.subj1.online(s).run(j).eeg;
        fs = 512;
        target_freqs = 4:2:30;
        
        for k = 1:length(hyp)
            if k+1 > length(pos)
                continue; % prevent out-of-bounds access
            end
            disp(j);
            disp(k);
            disp(pos(k));
            disp(pos(k+1));
            data = eeg(pos(k):pos(k+1), :);  % segment EEG for this trial
            
            for n = 1:32
                x = data(:, n);  % EEG channel

                % Compute PSD
                [Pxx, f] = pwelch(x, [], [], [], fs);

                % Interpolate PSD to fixed target frequencies (14 bins)
                Pxx_interp = interp1(f, Pxx, target_freqs, 'linear', 0);

                if hyp(k) == 7691  % Left Hand class
                    subj_left_features(l_count,:,n) = Pxx_interp;
                elseif hyp(k) == 7701  % Right Hand class
                    subj_right_features(r_count,:,n) = Pxx_interp;
                end
            end

            % Increment counters *outside* the channel loop
            if hyp(k) == 7691
                l_count = l_count + 1;
            elseif hyp(k) == 7701
                r_count = r_count + 1;
            end
        end
    end
end

[subj1_left_feat, subj1_right_feat]= calcSessionFeat(3,subj2_data);


%% Fisherscore prepare - mean,std
%30*14*32형태의  array에서 30개의 feature를 같은 위치 (14*32)에 있는 위치,를 기반으로 30개의
%point끼리 mean과 std를 계산
features=subj1_left_feat;
% Mean across the first dimension (trials)
subj1_left_mean_feat = squeeze(mean(features, 1));  % result: 14 x 32
% Standard deviation across the first dimension (trials)
subj1_left_std_feat = squeeze(std(features, 0, 1));  % result: 14 x 32

features=subj1_right_feat;
subj1_right_mean_feat = squeeze(mean(features, 1));  % result: 14 x 32
% Standard deviation across the first dimension (trials)
subj1_right_std_feat = squeeze(std(features, 0, 1));  % result: 14 x 32

%% Scaleogram
% Define frequency axis (y-axis) and channel axis (x-axis)
freqs = 4:2:30;           % 14 frequencies
channels = 1:32;          % 32 channels

%% Plot mean feature for Left Hand trials
figure;
imagesc(channels, freqs, subj1_left_mean_feat);
xlabel('Channel');
ylabel('Frequency (Hz)');
title('Left Hand - Mean PSD Feature (Scalogram View)');
colorbar;
set(gca, 'YDir', 'normal');  % so low frequencies are at the bottom

%% STD scaleogram
figure;
imagesc(1:32, 4:2:30, subj1_left_std_feat);  % 14x32
xlabel('Channel');
ylabel('Frequency (Hz)');
title('Left Hand - Std PSD Feature (Scalogram View)');
colorbar;
set(gca, 'YDir', 'normal');

%% Plot mean feature for Right Hand trials
figure;
imagesc(channels, freqs, subj1_right_mean_feat);
xlabel('Channel');
ylabel('Frequency (Hz)');
title('Right Hand - Mean PSD Feature (Scalogram View)');
colorbar;
set(gca, 'YDir', 'normal');  % so low frequencies are at the bottom

%% STD scaleogram
figure;
imagesc(1:32, 4:2:30, subj1_right_std_feat);  % 14x32
xlabel('Channel');
ylabel('Frequency (Hz)');
title('Right Hand - Std PSD Feature (Scalogram View)');
colorbar;
set(gca, 'YDir', 'normal');

%% Task 2.2 calculate F-score of all feature(448)
% 1. computer the fisher score, of the each extracted features. (using mean /
%std) for both subject F=abs(mean_class1-mean_class2)/sqrt(abs(std_class1^2-std_class2^2)))
% 2. for subject 2 only, find top 10 features (what channel,band) and
% comment on stability of 6 online sessions.


%for session 1
subj1_session1_fscore =createArray(14,32);

for i=1:14 %band
    for j=1:32 %channel
        f_score=abs(subj1_right_mean_feat(i,j)-subj1_left_mean_feat(i,j))/sqrt(abs(subj1_right_std_feat(i,j)^2-subj1_left_std_feat(i,j)^2));
        disp(f_score)
        subj1_session1_fscore(i,j) =f_score;
    end
end
% save("subj1_session1_fscore.mat",'subj1_session1_fscore');
