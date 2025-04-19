%% Feature Selection + Comparison using average of (MAV and VAR)
% clear all
% close all
% clc
% %% save mat features in computer
% % 
% % save('saveA.mat','A');
% % example = matfile('saveA.mat');
% % C = example.A;
% 
% %% VF
% vf_mav=matfile('VF_feature_mav.mat');
% vf_var=matfile('VF_feature_var.mat');
% vf_feature_label=matfile('VF_feature_label.mat');
% % properties load
% vf_mav=vf_mav.MAV_feature;
% vf_var=vf_var.VAR_feature;
% vf_feature_label=vf_feature_label.featureLabels;
% 
% pinch_mav=matfile('Pinch_feature_mav.mat');
% pinch_var=matfile('Pinch_feature_var.mat');
% pinch_feature_label=matfile('Pinch_feature_label.mat');
% % properties load
% pinch_mav=pinch_mav.MAV_feature;
% pinch_var=pinch_var.VAR_feature;
% pinch_feature_label=pinch_feature_label.featureLabels;
% 
% flex_mav=matfile('Flex_feature_mav.mat');
% flex_var=matfile('Flex_feature_var.mat');
% flex_feature_label=matfile('Flex_feature_label.mat');
% % properties load
% flex_mav=flex_mav.MAV_feature;
% flex_var=flex_var.VAR_feature;
% flex_feature_label=flex_feature_label.featureLabels;
% 
% %% comparison graph for (window = 0.1sec, overlap = 0)
% 
% MAV_vf = vf_mav;
% VAR_vf = vf_var;
% MAV_pinch = pinch_mav;
% VAR_pinch = pinch_var;
% MAV_flex = flex_mav;
% VAR_flex = flex_var;
% 
% 
% TriggerVF=vf_feature_label;
% TriggerPinch=pinch_feature_label;
% TriggerFlex=flex_feature_label;
% 
% %VF
% MAV_vf_sti = MAV_vf(find(TriggerVF==1));
% MAV_vf_rest = MAV_vf(find(TriggerVF==0));
% 
% VAR_vf_sti = VAR_vf(find(TriggerVF==1));
% VAR_vf_rest = VAR_vf(find(TriggerVF==0));
% 
% %Pinch
% MAV_pinch_sti = MAV_pinch(find(TriggerPinch==1));
% MAV_pinch_rest = MAV_pinch(find(TriggerPinch==0));
% 
% VAR_pinch_sti = VAR_pinch(find(TriggerPinch==1));
% VAR_pinch_rest = VAR_pinch(find(TriggerPinch==0));
% 
% %Flex
% MAV_flex_sti = MAV_flex(find(TriggerFlex==1));
% MAV_flex_rest = MAV_flex(find(TriggerFlex==0));
% 
% VAR_flex_sti = VAR_flex(find(TriggerFlex==1));
% VAR_flex_rest = VAR_flex(find(TriggerFlex==0));


%% 1. GROUP - F score feature validation

% 각 윈도우마다 계산된 MAV와 VAR 값들
% feat1_rest = MAV_pinch_rest;
% feat1_sti = MAV_pinch_sti;
% 
% feat2_rest = VAR_pinch_rest;
% feat2_sti = VAR_pinch_sti;
% 
% % Group mean per feature
% mean_rest_MAV = mean(feat1_rest); % Rest 클래스의 MAV 평균
% mean_sti_MAV = mean(feat1_sti);   % VF Stimulus 클래스의 MAV 평균
% 
% mean_rest_VAR = mean(feat2_rest); % Rest 클래스의 VAR 평균
% mean_sti_VAR = mean(feat2_sti);   % VF Stimulus 클래스의 VAR 평균
% 
% % total mean for each feature
% mean_total_MAV = mean([feat1_rest, feat1_sti]); % MAV 전체 평균
% mean_total_VAR = mean([feat2_rest, feat2_sti]); % VAR 전체 평균
% 
% % Within-group variance
% var_rest_MAV = var(feat1_rest); % Rest class - var of  MAV
% var_sti_MAV = var(feat1_sti);   % Stimulus class - var of MAV
% 
% var_rest_VAR = var(feat2_rest); % Rest class - var of VAR 
% var_sti_VAR = var(feat2_sti);   % VF Stimulus class - var of VAR
% 
% %Between-group variance
% between_group_variance_MAV = ((length(feat1_rest) * (mean_rest_MAV - mean_total_MAV)^2) + ...
%                             (length(feat1_sti) * (mean_sti_MAV - mean_total_MAV)^2)) / (length(feat1_rest) + length(feat1_sti));
% 
% between_group_variance_VAR = ((length(feat2_rest) * (mean_rest_VAR - mean_total_VAR)^2) + ...
%                              (length(feat2_sti) * (mean_sti_VAR - mean_total_VAR)^2)) / (length(feat2_rest) + length(feat2_sti));
% 
% % 그룹 내 분산 (Within-group variance) 계산 (각 그룹의 분산을 합산)
% within_group_variance_MAV = ((length(feat1_rest) - 1) * var_rest_MAV + (length(feat1_sti) - 1) * var_sti_MAV) / (length(feat1_rest) + length(feat1_sti) - 2);
% within_group_variance_VAR = ((length(feat2_rest) - 1) * var_rest_VAR + (length(feat2_sti) - 1) * var_sti_VAR) / (length(feat2_rest) + length(feat2_sti) - 2);
% 
% % F-score
% F_MAV = between_group_variance_MAV / within_group_variance_MAV; % MAV의 F-값
% F_VAR = between_group_variance_VAR / within_group_variance_VAR; % VAR의 F-값
% 
% % 결과 출력
% fprintf('VF signal MAV F-value: %.4f\n', F_MAV);
% fprintf('VF signal VAR F-value: %.4f\n', F_VAR);

%% 2. SNR calculation (Rest vs Sti per class)
%formula = SNR(db)=20*log10(mean(MAV_sti))/(mean(MAV_rest))

%if you need you can change name.. 
% feat1_rest = MAV_flex_rest;
% feat1_sti = MAV_flex_sti;
% 
% feat2_rest = VAR_flex_rest;
% feat2_sti = VAR_flex_sti;
% 
% SNR_feat1=20*log10(mean(feat1_sti)/mean(feat1_rest));
% SNR_feat2=20*log10(mean(feat2_sti)/mean(feat2_rest));
% 
% fprintf('Flex Signal MAV Feature SNR(dB) : %.4f\n',SNR_feat1);
% fprintf('Flex Signal VAR Feature SNR(dB) : %.4f\n',SNR_feat2);

%stimulation vs stimulation (bonus question)
class1_rest_MAV = MAV_vf_rest;
class2_sti_MAV = MAV_vf_sti;

class1_rest_VAR = VAR_vf_rest;
class2_sti_VAR = VAR_vf_sti;

SNR_feat1=20*log10(mean(class2_sti_MAV)/mean(class1_rest_MAV));
SNR_feat2=20*log10(mean(class2_sti_VAR)/mean(class1_rest_VAR));


fprintf('VF vs Pinch MAV SNR(dB) : %.4f\n',SNR_feat1);
fprintf('VF vs Pinch VAR SNR(dB) : %.4f\n',SNR_feat2);

