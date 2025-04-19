clear all
close all
clc

%%Get preprocessed data(bandpass+notch filter)
subject1=load("processed_EMG_data_subject1.mat"); 
subject2=load("processed_EMG_data_subject2.mat");

%% Feature extraction per trial( window) by subjects.
%% MAV feature

% with python...

%% Zero crossing Rate(ZCR)

