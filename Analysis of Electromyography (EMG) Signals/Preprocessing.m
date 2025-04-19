clear all
close all
clc

%% Import Data
load('../subject1.mat');

signal=subject.run(1).emg; %N datapoints * 4channel
header=subject.run(1).header; %N
fs=header.fs;
labels=header.Label;
typ=header.EVENT.TYP; %hyp 32766-->loop(1000,768,...)-->32766
pos=header.EVENT.POS; %position of each typ

%% Extract the first trial of subject 1 data.
%% 1. Plot time series signal over time with triggers
%% Extract Trial 1 Data
trial_start_idx = find(typ == 1000, 1); % First occurrence of trial start
fix_idx = find(typ == 768, 1); % First occurrence of fixation
task_cue_idx = find(typ == 100 | typ == 200 | typ == 300, 1); % Task cue
task_start_idx = find(typ == 101 | typ == 201 | typ == 301, 1); % Task execution start
task_end_idx = find(typ == 102 | typ == 202 | typ == 302, 1); % Task execution end

%% Extract time windows
rest_start = pos(trial_start_idx); % Start of rest period
fix_start = pos(fix_idx); % Start of fixation
task_cue = pos(task_cue_idx); % Start of task
task_start = pos(task_start_idx); % Start of task
task_end = pos(task_end_idx); % End of task

%% Extract EMG signals from trial
time_vector = (1:length(signal)) / fs; % Convert samples to seconds
trial_time = time_vector(rest_start:task_end); %start~end all data of first trial
trial_signal = signal(rest_start:task_end, :); 
% 
% Plot EMG Signals with Trigger Locations
% figure;
% hold on;
% Number of EMG channels
% num_channels = size(trial_signal, 2); 
% colors = lines(num_channels); % Assign unique colors for each EMG channel
% Plot each EMG channel with labels
% for ch = 1:num_channels
%     plot(trial_time, trial_signal(:, ch), 'Color', colors(ch, :), 'LineWidth', 1.5);
% end
% Label the EMG channels on the y-axis
% yticks(linspace(min(ylim), max(ylim), num_channels)); % Auto-spacing
% yticklabels(labels);
% ylabel('EMG Channels');
% Define trigger positions and labels
% trigger_times = time_vector([rest_start, fix_start, task_cue, task_start, task_end]);
% trigger_labels = {'Rest Start', 'Fixation', 'Task Cue', 'Task Start', 'Task End'};
% trigger_colors = {'g', 'b', 'm', 'r', 'k'}; % Unique colors for triggers
% Overlay vertical stems for triggers with text labels
% for i = 1:length(trigger_times)
%     stem([trigger_times(i) trigger_times(i)], [min(trial_signal(:)) max(trial_signal(:))], 'Color', trigger_colors{i}, 'LineStyle', '--', 'Marker', 'none', 'LineWidth', 1);
%     text(trigger_times(i), max(trial_signal(:)) + 0.2, trigger_labels{i}, 'Color', trigger_colors{i}, 'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
% end
% xlabel('Time (s)');
% title('EMG Time Series with Trigger Events');
% hold off;
% hold off;
% Define sensor names and colors
sensor_labels = labels;
sensor_colors = {'r', 'g', 'b', 'k'};  % Assign unique colors for each sensor

figure;
hold on;

% Loop through each EMG sensor (4 subplots)
for ch = 1:4
    subplot(4,1,ch);  % Create 4 subplots (one per EMG sensor)
    hold on;
    
    % Plot the EMG signal for the current sensor
    plot(trial_time, trial_signal(:, ch), 'Color', sensor_colors{ch}, 'LineWidth', 1.5);
    
    % Define trigger positions and labels
    trigger_times = time_vector([rest_start, fix_start, task_cue, task_start, task_end]);
    trigger_labels = {'Rest Start', 'Fixation', 'Task Cue', 'Task Start', 'Task End'};
    trigger_colors = {'g', 'b', 'm', 'r', 'k'}; % Unique colors for triggers

    % Overlay vertical stems for triggers with text labels
    for i = 1:length(trigger_times)
        stem([trigger_times(i) trigger_times(i)], ...
            [min(trial_signal(:, ch)) max(trial_signal(:, ch))], ...
            'Color', trigger_colors{i}, 'LineStyle', '--', 'Marker', 'none', 'LineWidth', 1);
        
        text(trigger_times(i), max(trial_signal(:, ch)) * 0.9, trigger_labels{i}, ...
            'Color', trigger_colors{i}, 'FontSize', 8, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    end

    % Y-axis label for each subplot
    ylabel([sensor_labels{ch} ' Amp(uV)']);
    
    % Title for each sensor
    title(['EMG Signal (subject 1, run 1, trial 1) - ' sensor_labels{ch}]);

    % X-axis label only for the last subplot
    if ch == 4
        xlabel('Time (s)');
    else
        xticklabels([]); % Hide x-axis labels for upper plots
    end

    hold off;
end

hold off;



%% 2. Extract rest and Task period distal Flexor muscle 
distal_flexor_idx=find(strcmp(labels, 'FlxDist')); % 4번째 idx
rest_signal=signal(rest_start:fix_start,distal_flexor_idx);
task_signal=signal(task_start:task_end,distal_flexor_idx);

%% Compute and Plot PSD for Rest vs. Task
[pxx_rest, f_rest] = pwelch(rest_signal, fs, [], [], fs);
[pxx_task, f_task] = pwelch(task_signal, fs, [], [], fs);

figure;
semilogy(f_rest, pxx_rest, 'b', 'LineWidth', 1.5); hold on;
semilogy(f_task, pxx_task, 'r', 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Power Spectral Density (dB/Hz)');
title('PSD Comparison of Rest vs. Task');
legend('Rest Period', 'Task Period');
hold off;

%% Bandpass Filtering for EMG (20-450 Hz)
[b, a] = butter(4, [20 255] / (fs / 2), 'bandpass');
filtered_signal = filtfilt(b, a, signal);

% signal=filtered_signal;
% distal_flexor_idx=find(strcmp(labels, 'FlxDist')); % 4번째 idx
% rest_signal=signal(rest_start:fix_start,distal_flexor_idx);
% task_signal=signal(task_start:task_end,distal_flexor_idx);
% 
% %% Compute and Plot PSD for Rest vs. Task
% [pxx_rest, f_rest] = pwelch(rest_signal, fs, [], [], fs);
% [pxx_task, f_task] = pwelch(task_signal, fs, [], [], fs);
% 
% figure;
% semilogy(f_rest, pxx_rest, 'b', 'LineWidth', 1.5); hold on;
% semilogy(f_task, pxx_task, 'r', 'LineWidth', 1.5);
% xlabel('Frequency (Hz)');
% ylabel('Power Spectral Density (dB/Hz)');
% title('PSD Comparison of Rest vs. Task');
% legend('Rest Period', 'Task Period');
% hold off;




%% Extract and Store Task Periods for All Trials

%% Load Data
load('../subject1.mat'); % Load subject 1 data
fs = subject.run(1).header.fs; % Sampling frequency 512

%% Define EMG Processing Parameters
low_cutoff = 20; % Lower cutoff frequency (Hz)
high_cutoff = 255; % Upper cutoff (max fs/2-1 to prevent Nyquist issues)
notch_freq = 60; % Notch filter frequency (Powerline interference)
num_subjects = 2; % Total subjects

%% Bandpass Filter Design (20-250 Hz)
[b_band, a_band] = butter(4, [low_cutoff high_cutoff] / (fs / 2), 'bandpass');

%% Notch Filter Design (Remove 60 Hz Powerline Interference)
d = designfilt('bandstopiir', 'FilterOrder', 2, ...
               'HalfPowerFrequency1', notch_freq-2, 'HalfPowerFrequency2', notch_freq+2, ...
               'DesignMethod', 'butter', 'SampleRate', fs);

%% Initialize Storage for Filtered Data
task_data = {}; % Store processed EMG trials
task_labels = []; % Store corresponding task class labels

%% Loop Through Subjects
for subj = 2:2 %for subj = 1:num_subjects 
    fprintf('Processing Sub ject %d...\n', subj);

    % Load subject data dynamically
    filename = ['../subject' num2str(subj) '.mat'];
    loaded_data = load(filename);
    
    % Extract subject struct (assuming it's named 'subject' in the .mat file)
    subject_data = loaded_data.subject;
    
    % % Get Subject Data
    % subject_data = subject;
    
    
    %% Loop Through Runs
    for run = 1:length(subject_data.run)
        fprintf('  Processing Run %d...\n', run);
        
        % Extract EMG signals
        emg_signal = subject_data.run(run).emg; % Raw EMG data (N x 4 channels)
        header = subject_data.run(run).header;
        typ = header.EVENT.TYP; % Event triggers
        pos = header.EVENT.POS; % Trigger positions
        
        % Apply Bandpass Filter
        filtered_emg = filtfilt(b_band, a_band, emg_signal); 
        
        % Apply Notch Filter (60 Hz)
        filtered_emg = filtfilt(d, filtered_emg);
        
        %% Extract Task Periods for Each Trial
        trial_indices = find(typ == 1000); % Find trial start triggers
        
        for i = 1:length(trial_indices)
            trial_start = pos(trial_indices(i));
            % task_cue_idx = find(typ == 100 | typ == 200 | typ == 300, 1, 'first', 'after', trial_indices(i));
            % task_start_idx = find(typ == 101 | typ == 201 | typ == 301, 1, 'first', 'after', task_cue_idx);
            % task_end_idx = find(typ == 102 | typ == 202 | typ == 302, 1, 'first', 'after', task_start_idx);
            % Find task cue (Pinch, Point, Grasp)
            task_cue_idx = find(typ(trial_indices(i):end) == 100 | ...
                                typ(trial_indices(i):end) == 200 | ...
                                typ(trial_indices(i):end) == 300, 1, 'first') + trial_indices(i) - 1;
            
            % Find task start (Pinch, Point, Grasp execution)
            task_start_idx = find(typ(trial_indices(i):end) == 101 | ...
                                  typ(trial_indices(i):end) == 201 | ...
                                  typ(trial_indices(i):end) == 301, 1, 'first') + trial_indices(i) - 1;
            
            % Find task end (Task execution ends)
            task_end_idx = find(typ(trial_indices(i):end) == 102 | ...
                                typ(trial_indices(i):end) == 202 | ...
                                typ(trial_indices(i):end) == 302, 1, 'first') + trial_indices(i) - 1;

            
            if ~isempty(task_start_idx) && ~isempty(task_end_idx)
                task_start = pos(task_start_idx);
                task_end = pos(task_end_idx);
                
                % Extract task period signal
                task_signal = filtered_emg(task_start:task_end, :);
                
                % Store trial data
                task_data{end+1} = task_signal;
                
                % Assign class label based on task cue
                cue_type = typ(task_cue_idx);
                if cue_type == 100
                    task_labels(end+1) = 1; % Pinch
                elseif cue_type == 200
                    task_labels(end+1) = 2; % Point
                elseif cue_type == 300
                    task_labels(end+1) = 3; % Grasp
                end
            end
        end
    end
end


%% Convert to Variable-Length Format
num_trials = length(task_data); %% task만 각각 전부저장!! (360 * 1)
num_sensors = size(filtered_emg, 2);

% Instead of a fixed-size matrix, use a cell array
task_data_matrix = cell(num_trials, 1); 

for i = 1:num_trials
    task_data_matrix{i} = task_data{i}'; % Store each trial as (sensors × samples_task)
end

%% Save Processed Data
save('processed_EMG_data_subject2.mat', 'task_data_matrix', 'task_labels', 'fs', 'labels');
fprintf('Processing complete. Data saved as processed_EMG_data.mat\n');
% 
% %% Convert to Matrix Format
% num_trials = length(task_data);
% num_sensors = size(filtered_emg, 2);
% num_samples = max(cellfun(@(x) size(x, 1), task_data)); % Find longest trial
% 
% task_data_matrix = nan(num_trials, num_sensors, num_samples);
% for i = 1:num_trials
%     trial_length = size(task_data{i}, 1);
%     task_data_matrix(i, :, 1:trial_length) = task_data{i}';
% end
% 
% %% Save Processed Data
% save('processed_EMG_data.mat', 'task_data_matrix', 'task_labels', 'fs', 'labels');
% fprintf('Processing complete. Data saved as processed_EMG_data.mat\n');