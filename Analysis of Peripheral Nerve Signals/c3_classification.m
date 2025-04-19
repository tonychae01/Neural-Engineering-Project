% close all;clc;
% %%
% vf_mav=matfile('VF_feature_mav.mat');
% vf_var=matfile('VF_feature_var.mat');
% 
% % properties load
% MAV_vf=vf_mav.MAV_feature;
% VAR_vf=vf_var.VAR_feature;
% 
% pinch_mav=matfile('Pinch_feature_mav.mat');
% pinch_var=matfile('Pinch_feature_var.mat');
% % properties load
% MAV_pinch=pinch_mav.MAV_feature;
% VAR_pinch=pinch_var.VAR_feature;
% 
% flex_mav=matfile('Flex_feature_mav.mat');
% flex_var=matfile('Flex_feature_var.mat');
% % properties load
% MAV_flex=flex_mav.MAV_feature;
% VAR_flex=flex_var.VAR_feature;
% 
% pinch_feature_label=matfile('Pinch_feature_label.mat');
% pinch_feature_label=pinch_feature_label.featureLabels;
% TriggerPinch=pinch_feature_label;
% 
% vf_feature_label=matfile('VF_feature_label.mat');
% vf_feature_label=vf_feature_label.featureLabels;
% TriggerVF=vf_feature_label;
% 
% flex_feature_label=matfile('Flex_feature_label.mat');
% flex_feature_label=flex_feature_label.featureLabels;
% TriggerFlex=flex_feature_label;
% 
% 
% 
% 
% % Inputs: 
% % --------
% % MAVClass1: the features of the VF case (stimulus and rest features)
% MAVClass1 = MAV_vf;
% % MAVClass2: the features of the Pinch case (stimulus and rest features)
% % MAVClass2 = MAV_pinch;
% MAVClass2 = MAV_pinch;
% 
% VARClass1 = VAR_vf;
% % MAVClass2: the features of the Pinch case (stimulus and rest features)
% % VARClass2 = VAR_pinch;
% VARClass2 = VAR_pinch;
% 
% % TriggerClass1: labels for VF features (stimulus or rest label)
% TriggerClass1 = TriggerVF;
% % TriggerClass2: labels for Pinch features (stimulus or rest label)
% % TriggerClass2 = TriggerPinch;
% TriggerClass2 = TriggerPinch;
% 
% % Build the datasets
% MAV_class1 = MAVClass1(find(TriggerClass1==1));
% MAV_rest1 = MAVClass1(find(TriggerClass1==0));
% 
% VAR_class1 = VARClass1(find(TriggerClass1==1));
% VAR_rest1 = VARClass1(find(TriggerClass1==0));
% 
% MAV_class2 = MAVClass2(find(TriggerClass2==1));
% MAV_rest2 = MAVClass2(find(TriggerClass2==0));
% 
% VAR_class2 = VARClass2(find(TriggerClass2==1));
% VAR_rest2 = VARClass2(find(TriggerClass2==0));
% 
% % Concantenate the rest classes
% MAV_rest = [MAV_rest1 MAV_rest2];
% VAR_rest = [VAR_rest1 VAR_rest2];
% 
% 
% %%
% % Class1 vs Rest dataset
% MAV_Data_Class1vsRest = [MAV_class1 MAV_rest];
% MAV_Labels_Class1vsRest = [ones(1,length(MAV_class1)) 2*ones(1,length(MAV_rest))];
% 
% VAR_Data_Class1vsRest = [VAR_class1 VAR_rest];
% VAR_Labels_Class1vsRest = MAV_Labels_Class1vsRest;
% 
% % Class2 vs Rest dataset
% MAV_Data_Class2vsRest = [MAV_class2 MAV_rest];
% MAV_Labels_Class2vsRest = [ones(1,length(MAV_class2)) 2*ones(1,length(MAV_rest))];
% 
% VAR_Data_Class2vsRest = [VAR_class2 VAR_rest];
% VAR_Labels_Class2vsRest = MAV_Labels_Class2vsRest;
% 
% % Class1 vs Class2 dataset
% MAV_Data_Class1vsClass2 = [MAV_class1 MAV_class2];
% MAV_Labels_Class1vsClass2 = [ones(1,length(MAV_class1)) 2*ones(1,length(MAV_class2))];
% 
% VAR_Data_Class1vsClass2 = [VAR_class1 VAR_class2];
% VAR_Labels_Class1vsClass2 = MAV_Labels_Class1vsClass2;
% 
% %%
% % Both feature datasets
% MAVVAR_Data_Class1vsRest = [MAV_Data_Class1vsRest; VAR_Data_Class1vsRest];
% MAVVAR_Labels_Class1vsRest = MAV_Labels_Class1vsRest;
% 
% MAVVAR_Data_Class2vsRest = [MAV_Data_Class2vsRest; VAR_Data_Class2vsRest];
% MAVVAR_Labels_Class2vsRest = MAV_Labels_Class2vsRest;
% 
% MAVVAR_Data_Class1vsClass2 = [MAV_Data_Class1vsClass2; VAR_Data_Class1vsClass2];
% MAVVAR_Labels_Class1vsClass2 = MAV_Labels_Class1vsClass2;
% 
% %%
% % Classify all combinations (training set)
% k = 10; % for k-fold cross validation
% c1 = cvpartition(length(MAV_Labels_Class1vsRest),'KFold',k);
% c2 = cvpartition(length(VAR_Labels_Class1vsRest),'KFold',k);
% c3 = cvpartition(length(MAVVAR_Labels_Class1vsRest),'KFold',k);
% c4 = cvpartition(length(MAV_Labels_Class2vsRest),'KFold',k);
% c5 = cvpartition(length(VAR_Labels_Class2vsRest),'KFold',k);
% c6 = cvpartition(length(MAVVAR_Labels_Class2vsRest),'KFold',k);
% c7 = cvpartition(length(MAV_Labels_Class1vsClass2),'KFold',k);
% c8 = cvpartition(length(VAR_Labels_Class1vsClass2),'KFold',k);
% c9 = cvpartition(length(MAVVAR_Labels_Class1vsClass2),'KFold',k);
% 
% % Repeat the following for i=1:k, and average performance metrics across all iterations
% i=1;
% ConfMatTotal_MAV_C1rest = zeros(2, 2);
% ConfMatTotal_VAR_C1rest = zeros(2, 2);
% ConfMatTotal_MAVVAR_C1rest = zeros(2, 2);
% 
% ConfMatTotal_MAV_C2rest = zeros(2, 2);
% ConfMatTotal_VAR_C2rest = zeros(2, 2);
% ConfMatTotal_MAVVAR_C2rest = zeros(2, 2);
% 
% ConfMatTotal_MAV_C1C2 = zeros(2, 2);
% ConfMatTotal_VAR_C1C2 = zeros(2, 2);
% ConfMatTotal_MAVVAR_C1C2 = zeros(2, 2);
% 
% % loop over all k-folds and average the performance
% for i=1:k
% 
%     %Class 1 vs Rest
%     [TstMAVFC1Rest TstMAVErrC1Rest] = classify(MAV_Data_Class1vsRest(c1.test(i))',MAV_Data_Class1vsRest(c1.training(i))',MAV_Labels_Class1vsRest(c1.training(i)));
%     [TstCM_MAV_C1rest dum1 TstAcc_MAV_C1rest dum2] = confusion(MAV_Labels_Class1vsRest(c1.test(i)), TstMAVFC1Rest);
% 
%     [TstVARFC1Rest TstVARErrC1Rest] = classify(VAR_Data_Class1vsRest(c2.test(i))',VAR_Data_Class1vsRest(c2.training(i))',VAR_Labels_Class1vsRest(c2.training(i)));
%     [TstCM_VAR_C1rest dum1 TstAcc_VAR_C1rest dum2] = confusion(VAR_Labels_Class1vsRest(c2.test(i)), TstVARFC1Rest);
% 
%     [TstMAVVARFC1Rest TstMAVVARErrC1Rest] = classify(MAVVAR_Data_Class1vsRest(:,c3.test(i))',MAVVAR_Data_Class1vsRest(:,c3.training(i))',MAVVAR_Labels_Class1vsRest(c3.training(i)));
%     [TstCM_MAVVAR_C1rest dum1 TstAcc_MAVVAR_C1rest dum2] = confusion(MAVVAR_Labels_Class1vsRest(c3.test(i)), TstMAVVARFC1Rest);
%     % display(TstCM_MAV_C1rest);
%     ConfMatTotal_MAV_C1rest = ConfMatTotal_MAV_C1rest + TstCM_MAV_C1rest;
%     ConfMatTotal_VAR_C1rest = ConfMatTotal_VAR_C1rest + TstCM_VAR_C1rest;
%     ConfMatTotal_MAVVAR_C1rest = ConfMatTotal_MAVVAR_C1rest + TstCM_MAVVAR_C1rest;
% 
% 
% 
%     % Class2 vs Rest
%     [TstMAVFC2Rest TstMAVErrC2Rest] = classify(MAV_Data_Class2vsRest(c4.test(i))',MAV_Data_Class2vsRest(c4.training(i))',MAV_Labels_Class2vsRest(c4.training(i)));
%     [TstCM_MAV_C2rest dum1 TstAcc_MAV_C2rest dum2] = confusion(MAV_Labels_Class2vsRest(c4.test(i)), TstMAVFC2Rest);
% 
%     [TstVARFC2Rest TstVARErrC2Rest] = classify(VAR_Data_Class2vsRest(c5.test(i))',VAR_Data_Class2vsRest(c5.training(i))',VAR_Labels_Class2vsRest(c5.training(i)));
%     [TstCM_VAR_C2rest dum1 TstAcc_VAR_C2rest dum2] = confusion(VAR_Labels_Class2vsRest(c5.test(i)), TstVARFC2Rest);
% 
%     [TstMAVVARFC2Rest TstMAVVARErrC2Rest] = classify(MAVVAR_Data_Class2vsRest(:,c6.test(i))',MAVVAR_Data_Class2vsRest(:,c6.training(i))',MAVVAR_Labels_Class2vsRest(c6.training(i)));
%     [TstCM_MAVVAR_C2rest dum1 TstAcc_MAVVAR_C2rest dum2] = confusion(MAVVAR_Labels_Class2vsRest(c6.test(i)), TstMAVVARFC2Rest);
% 
% 
%     ConfMatTotal_MAV_C2rest = ConfMatTotal_MAV_C2rest + TstCM_MAV_C2rest;
%     ConfMatTotal_VAR_C2rest = ConfMatTotal_VAR_C2rest + TstCM_VAR_C2rest;
%     ConfMatTotal_MAVVAR_C2rest = ConfMatTotal_MAVVAR_C2rest + TstCM_MAVVAR_C2rest;
% 
%     % Class1 vs Class2
%     [TstMAVFC1C2 TstMAVErrC1C2] = classify(MAV_Data_Class1vsClass2(c7.test(i))',MAV_Data_Class1vsClass2(c7.training(i))',MAV_Labels_Class1vsClass2(c7.training(i)));
%     [TstCM_MAV_C1C2 dum1 TstAcc_MAV_C1C2 dum2] = confusion(MAV_Labels_Class1vsClass2(c7.test(i)), TstMAVFC1C2);
% 
%     [TstVARFC1C2 TstVARErrC1C2] = classify(VAR_Data_Class1vsClass2(c8.test(i))',VAR_Data_Class1vsClass2(c8.training(i))',VAR_Labels_Class1vsClass2(c8.training(i)));
%     [TstCM_VAR_C1C2 dum1 TstAcc_VAR_C1C2 dum2] = confusion(VAR_Labels_Class1vsClass2(c8.test(i)), TstVARFC1C2);
% 
%     [TstMAVVARFC1C2 TstMAVVARErrC1C2] = classify(MAVVAR_Data_Class1vsClass2(:,c9.test(i))',MAVVAR_Data_Class1vsClass2(:,c9.training(i))',MAVVAR_Labels_Class1vsClass2(c9.training(i)));
%     [TstCM_MAVVAR_C1C2 dum1 TstAcc_MAVVAR_C1C2 dum2] = confusion(MAVVAR_Labels_Class1vsClass2(c9.test(i)), TstMAVVARFC1C2);
% 
%     ConfMatTotal_MAV_C1C2 = ConfMatTotal_MAV_C1C2 + TstCM_MAV_C1C2;
%     ConfMatTotal_VAR_C1C2 = ConfMatTotal_VAR_C1C2 + TstCM_VAR_C1C2;
%     ConfMatTotal_MAVVAR_C1C2 = ConfMatTotal_MAVVAR_C1C2 + TstCM_MAVVAR_C1C2;
% 
% end
% %%
% 
% 
% % Convert to percentages
% 
% % Print the average confusion matrix
% disp(ConfMatTotal_MAV_C1rest);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_MAV_C1rest(1,1)+ConfMatTotal_MAV_C1rest(2,2))/sum(ConfMatTotal_MAV_C1rest(:)));
% ConfMat=ConfMatTotal_MAV_C1rest;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% disp(ConfMatTotal_VAR_C1rest);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_VAR_C1rest(1,1)+ConfMatTotal_VAR_C1rest(2,2))/sum(ConfMatTotal_VAR_C1rest(:)));
% ConfMat=ConfMatTotal_VAR_C1rest;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% disp(ConfMatTotal_MAVVAR_C1rest);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_MAVVAR_C1rest(1,1)+ConfMatTotal_MAVVAR_C1rest(2,2))/sum(ConfMatTotal_MAVVAR_C1rest(:)));
% ConfMat=ConfMatTotal_MAVVAR_C1rest;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% 
% disp(ConfMatTotal_MAV_C2rest);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_MAV_C2rest(1,1)+ConfMatTotal_MAV_C2rest(2,2))/sum(ConfMatTotal_MAV_C2rest(:)));
% ConfMat=ConfMatTotal_MAV_C2rest;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% disp(ConfMatTotal_VAR_C2rest);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_VAR_C2rest(1,1)+ConfMatTotal_VAR_C2rest(2,2))/sum(ConfMatTotal_VAR_C2rest(:)));
% ConfMat=ConfMatTotal_VAR_C2rest;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% disp(ConfMatTotal_MAVVAR_C2rest);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_MAVVAR_C2rest(1,1)+ConfMatTotal_MAVVAR_C2rest(2,2))/sum(ConfMatTotal_MAVVAR_C2rest(:)));
% ConfMat=ConfMatTotal_MAVVAR_C2rest;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% 
% disp(ConfMatTotal_MAV_C1C2);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_MAV_C1C2(1,1)+ConfMatTotal_MAV_C1C2(2,2))/sum(ConfMatTotal_MAV_C1C2(:)));
% ConfMat=ConfMatTotal_MAV_C1C2;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% disp(ConfMatTotal_VAR_C1C2);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_VAR_C1C2(1,1)+ConfMatTotal_VAR_C1C2(2,2))/sum(ConfMatTotal_VAR_C1C2(:)));
% ConfMat=ConfMatTotal_VAR_C1C2;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);
% disp(ConfMatTotal_MAVVAR_C1C2);
% fprintf("accuracy: %.2f \n",(ConfMatTotal_MAVVAR_C1C2(1,1)+ConfMatTotal_MAVVAR_C1C2(2,2))/sum(ConfMatTotal_MAVVAR_C1C2(:)));
% ConfMat=ConfMatTotal_MAVVAR_C1C2;
% balance = (ConfMat(1,1) / (ConfMat(1,1) + ConfMat(1,2)) + ConfMat(2,2) / (ConfMat(2,1) + ConfMat(2,2))) / 2;
% fprintf("balance: %.2f \n",balance);

close all; clc;
%% Load features and labels
vf_mav = matfile('VF_feature_mav.mat');
vf_var = matfile('VF_feature_var.mat');

pinch_mav = matfile('Pinch_feature_mav.mat');
pinch_var = matfile('Pinch_feature_var.mat');

flex_mav = matfile('Flex_feature_mav.mat');
flex_var = matfile('Flex_feature_var.mat');

pinch_feature_label = matfile('Pinch_feature_label.mat');
pinch_feature_label = pinch_feature_label.featureLabels;
TriggerPinch = pinch_feature_label;

vf_feature_label = matfile('VF_feature_label.mat');
vf_feature_label = vf_feature_label.featureLabels;
TriggerVF = vf_feature_label;

flex_feature_label = matfile('Flex_feature_label.mat');
flex_feature_label = flex_feature_label.featureLabels;
TriggerFlex = flex_feature_label;

% Inputs: 
MAVClass1 = vf_mav.MAV_feature;
MAVClass2 = pinch_mav.MAV_feature;
MAVClass3 = flex_mav.MAV_feature;

VARClass1 = vf_var.VAR_feature;
VARClass2 = pinch_var.VAR_feature;
VARClass3 = flex_var.VAR_feature;

TriggerClass1 = TriggerVF;
TriggerClass2 = TriggerPinch;
TriggerClass3 = TriggerFlex;

% Build the datasets
MAV_class1 = MAVClass1(find(TriggerClass1 == 1));
MAV_rest1 = MAVClass1(find(TriggerClass1 == 0));

VAR_class1 = VARClass1(find(TriggerClass1 == 1));
VAR_rest1 = VARClass1(find(TriggerClass1 == 0));

MAV_class2 = MAVClass2(find(TriggerClass2 == 1));
MAV_rest2 = MAVClass2(find(TriggerClass2 == 0));

VAR_class2 = VARClass2(find(TriggerClass2 == 1));
VAR_rest2 = VARClass2(find(TriggerClass2 == 0));

MAV_class3 = MAVClass3(find(TriggerClass3 == 1));
MAV_rest3 = MAVClass3(find(TriggerClass3 == 0));

VAR_class3 = VARClass3(find(TriggerClass3 == 1));
VAR_rest3 = VARClass3(find(TriggerClass3 == 0));

% Concatenate the rest classes
MAV_rest = [MAV_rest1 MAV_rest2 MAV_rest3];
VAR_rest = [VAR_rest1 VAR_rest2 VAR_rest3];

% Prepare datasets
MAV_Data_4class = [MAV_class1 MAV_class2 MAV_class3 MAV_rest];
MAV_Labels_4class = [ones(1,length(MAV_class1)) 2*ones(1,length(MAV_class2)) 3*ones(1,length(MAV_class3)) 4*ones(1,length(MAV_rest))];

VAR_Data_4class = [VAR_class1 VAR_class2 VAR_class3 VAR_rest];
VAR_Labels_4class = MAV_Labels_4class; 

%% Cross-validation setup
k = 10; % 10-fold cross-validation
c1 = cvpartition(length(MAV_Labels_4class), 'KFold', k); % for MAV features
c2 = cvpartition(length(VAR_Labels_4class), 'KFold', k); % for VAR features
c3 = cvpartition(length(MAV_Labels_4class), 'KFold', k); % for MAV+VAR combined features (MAV_Data + VAR_Data)

% Initialize confusion matrices for each classifier
ConfMatTotal_MAV = zeros(4, 4);
ConfMatTotal_VAR = zeros(4, 4);
ConfMatTotal_MAVVAR = zeros(4, 4);

% Loop over all k-folds and calculate performance metrics
for i = 1:k
    % Classify using MAV features
    [TstMAVFC1, TstMAVErrC1] = classify(MAV_Data_4class(c1.test(i))', MAV_Data_4class(c1.training(i))', MAV_Labels_4class(c1.training(i)));
    [TstCM_MAV, ~, TstAcc_MAV, ~] = confusion(MAV_Labels_4class(c1.test(i)), TstMAVFC1);

    % Classify using VAR features
    [TstVARFC1, TstVARErrC1] = classify(VAR_Data_4class(c2.test(i))', VAR_Data_4class(c2.training(i))', VAR_Labels_4class(c2.training(i)));
    [TstCM_VAR, ~, TstAcc_VAR, ~] = confusion(VAR_Labels_4class(c2.test(i)), TstVARFC1);

    % Classify using both MAV and VAR features
    MAVVAR_Data_4class = [MAV_Data_4class; VAR_Data_4class]; % Combining MAV and VAR
    [TstMAVVARFC1, TstMAVVARErrC1] = classify(MAVVAR_Data_4class(:, c3.test(i))', MAVVAR_Data_4class(:, c3.training(i))', MAV_Labels_4class(c3.training(i)));
    [TstCM_MAVVAR, ~, TstAcc_MAVVAR, ~] = confusion(MAV_Labels_4class(c3.test(i)), TstMAVVARFC1);
    
    % Update confusion matrices
    ConfMatTotal_MAV = ConfMatTotal_MAV + TstCM_MAV;
    ConfMatTotal_VAR = ConfMatTotal_VAR + TstCM_VAR;
    ConfMatTotal_MAVVAR = ConfMatTotal_MAVVAR + TstCM_MAVVAR;
end

%% Calculate and print results
% Convert to percentages
ConfMat_MAV_percent = 100 * ConfMatTotal_MAV / sum(ConfMatTotal_MAV(:));
ConfMat_VAR_percent = 100 * ConfMatTotal_VAR / sum(ConfMatTotal_VAR(:));
ConfMat_MAVVAR_percent = 100 * ConfMatTotal_MAVVAR / sum(ConfMatTotal_MAVVAR(:));

% Print confusion matrices and accuracy
fprintf('MAV Confusion Matrix:\n');
disp(ConfMat_MAV_percent);
fprintf('MAV Accuracy: %.2f%%\n', (sum(diag(ConfMatTotal_MAV)) / sum(ConfMatTotal_MAV(:))) * 100);

fprintf('VAR Confusion Matrix:\n');
disp(ConfMat_VAR_percent);
fprintf('VAR Accuracy: %.2f%%\n', (sum(diag(ConfMatTotal_VAR)) / sum(ConfMatTotal_VAR(:))) * 100);

fprintf('MAV + VAR Confusion Matrix:\n');
disp(ConfMat_MAVVAR_percent);
fprintf('MAV + VAR Accuracy: %.2f%%\n', (sum(diag(ConfMatTotal_MAVVAR)) / sum(ConfMatTotal_MAVVAR(:))) * 100);

%% Balance calculation (average of recall and specificity)
balance_MAV = (ConfMatTotal_MAV(1,1) / (ConfMatTotal_MAV(1,1) + ConfMatTotal_MAV(1,2)) + ConfMatTotal_MAV(2,2) / (ConfMatTotal_MAV(2,1) + ConfMatTotal_MAV(2,2))) / 2;
fprintf('MAV Balance: %.2f\n', balance_MAV);

balance_VAR = (ConfMatTotal_VAR(1,1) / (ConfMatTotal_VAR(1,1) + ConfMatTotal_VAR(1,2)) + ConfMatTotal_VAR(2,2) / (ConfMatTotal_VAR(2,1) + ConfMatTotal_VAR(2,2))) / 2;
fprintf('VAR Balance: %.2f\n', balance_VAR);

balance_MAVVAR = (ConfMatTotal_MAVVAR(1,1) / (ConfMatTotal_MAVVAR(1,1) + ConfMatTotal_MAVVAR(1,2)) + ConfMatTotal_MAVVAR(2,2) / (ConfMatTotal_MAVVAR(2,1) + ConfMatTotal_MAVVAR(2,2))) / 2;
fprintf('MAV + VAR Balance: %.2f\n', balance_MAVVAR);

