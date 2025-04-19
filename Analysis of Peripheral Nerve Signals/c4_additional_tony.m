% close all;
% clc;
% 
% % Inputs: 
% % --------
% % MAVClass1: the features of the VF case (stimulus and rest features)
% MAVClass1 = MAV_vf;
% % MAVClass2: the features of the Pinch case (stimulus and rest features)
% MAVClass2 = MAV_pinch;
% 
% VARClass1 = VAR_vf;
% VARClass2 = VAR_pinch;
% 
% % TriggerClass1: labels for VF features (stimulus or rest label)
% TriggerClass1 = TriggerVF;
% % TriggerClass2: labels for Pinch features (stimulus or rest label)
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
% % Concatenate the rest classes
% MAV_rest = [MAV_rest1 MAV_rest2];
% VAR_rest = [VAR_rest1 VAR_rest2];
% 
% %% Class1 vs Rest dataset
% MAV_Data_Class1vsRest = [MAV_class1 MAV_rest];
% MAV_Labels_Class1vsRest = [ones(1,length(MAV_class1)) 2*ones(1,length(MAV_rest))];
% 
% VAR_Data_Class1vsRest = [VAR_class1 VAR_rest];
% VAR_Labels_Class1vsRest = MAV_Labels_Class1vsRest;
% 
% % Initialize k-fold cross-validation
% k = 10; % Number of folds
% c1 = cvpartition(length(MAV_Labels_Class1vsRest),'KFold',k);
% c2 = cvpartition(length(VAR_Labels_Class1vsRest),'KFold',k);
% c3 = cvpartition(length(MAVVAR_Labels_Class1vsRest),'KFold',k);
% 
% 
% % Loop over all k-folds and calculate performance
% for i = 1:k
%     % Class 1 vs Rest (MAV)
%     [TstMAVFC1Rest, TstMAVErrC1Rest] = classify(MAV_Data_Class1vsRest(c1.test(i))',MAV_Data_Class1vsRest(c1.training(i))',MAV_Labels_Class1vsRest(c1.training(i)));
%     [TstCM_MAV_C1rest, ~, TstAcc_MAV_C1rest(i), ~] = confusion(MAV_Labels_Class1vsRest(c1.test(i)), TstMAVFC1Rest);
% 
%     % Print confusion matrix for MAV Class 1 vs Rest
%     fprintf('Confusion Matrix for MAV Class 1 vs Rest - Fold %d:\n', i);
%     disp(TstCM_MAV_C1rest);
% 
% 
% 
%     % Class 1 vs Rest (VAR)
%     [TstVARFC1Rest, TstVARErrC1Rest] = classify(VAR_Data_Class1vsRest(c2.test(i))', VAR_Data_Class1vsRest(c2.training(i))', VAR_Labels_Class1vsRest(c2.training(i)));
%     [TstCM_VAR_C1rest, ~, TstAcc_VAR_C1rest(i), ~] = confusion(VAR_Labels_Class1vsRest(c2.test(i)), TstVARFC1Rest);
% 
%     % Print confusion matrix for VAR Class 1 vs Rest
%     fprintf('Confusion Matrix for VAR Class 1 vs Rest - Fold %d:\n', i);
%     disp(TstCM_VAR_C1rest);
% 
% 
%     % Class 1 vs Rest (MAV + VAR combined)
%     [TstMAVVARFC1Rest, TstMAVVARErrC1Rest] = classify(MAVVAR_Data_Class1vsRest(:, c3.test(i))', MAVVAR_Data_Class1vsRest(:, c3.training(i))', MAVVAR_Labels_Class1vsRest(c3.training(i)));
%     [TstCM_MAVVAR_C1rest, ~, TstAcc_MAVVAR_C1rest(i), ~] = confusion(MAVVAR_Labels_Class1vsRest(c3.test(i)), TstMAVVARFC1Rest);
% 
%     % Print confusion matrix for MAV + VAR Class 1 vs Rest
%     fprintf('Confusion Matrix for MAV+VAR Class 1 vs Rest - Fold %d:\n', i);
%     disp(TstCM_MAVVAR_C1rest);
% 
% 
% end
% 
% 
% 
% % % Output results
% 
% 
% % You can similarly calculate and output for other comparisons like Class 2 vs Rest and Class 1 vs Class 2


close all;
clc;

% Inputs and initial setup remains the same until the k-fold section
% ... [previous code remains unchanged until k-fold section] ...

% Inputs: 
% --------
% MAVClass1: the features of the VF case (stimulus and rest features)
% % MAVClass1 = MAV_vf;
% MAVClass2: the features of the Pinch case (stimulus and rest features)
MAVClass1 = MAV_pinch;

%% VARClass1 = VAR_vf;
VARClass1 = VAR_pinch;

% TriggerClass1: labels for VF features (stimulus or rest label)
%% TriggerClass1 = TriggerVF;
% TriggerClass2: labels for Pinch features (stimulus or rest label)
TriggerClass1 = TriggerPinch;

% Build the datasets
MAV_class1 = MAVClass1(find(TriggerClass1==1));
MAV_rest1 = MAVClass1(find(TriggerClass1==0));

VAR_class1 = VARClass1(find(TriggerClass1==1));
VAR_rest1 = VARClass1(find(TriggerClass1==0));

% MAV_class2 = MAVClass2(find(TriggerClass2==1));
% MAV_rest2 = MAVClass2(find(TriggerClass2==0));
% 
% VAR_class2 = VARClass2(find(TriggerClass2==1));
% VAR_rest2 = VARClass2(find(TriggerClass2==0));

% Concatenate the rest classes
MAV_rest = [MAV_rest1 MAV_rest2];
VAR_rest = [VAR_rest1 VAR_rest2];

%% Class1 vs Rest dataset
MAV_Data_Class1vsRest = [MAV_class1 MAV_rest];
MAV_Labels_Class1vsRest = [ones(1,length(MAV_class1)) 2*ones(1,length(MAV_rest))];

VAR_Data_Class1vsRest = [VAR_class1 VAR_rest];
VAR_Labels_Class1vsRest = MAV_Labels_Class1vsRest;

% Initialize matrices to accumulate confusion matrices
TotalCM_MAV_C1rest = zeros(2,2);
TotalCM_VAR_C1rest = zeros(2,2);
TotalCM_MAVVAR_C1rest = zeros(2,2);

% Initialize arrays for accuracy
TstAcc_MAV_C1rest = zeros(1,k);
TstAcc_VAR_C1rest = zeros(1,k);
TstAcc_MAVVAR_C1rest = zeros(1,k);

% Loop over all k-folds and calculate performance
for i = 1:k
    % Class 1 vs Rest (MAV)
    [TstMAVFC1Rest, TstMAVErrC1Rest] = classify(MAV_Data_Class1vsRest(c1.test(i))',MAV_Data_Class1vsRest(c1.training(i))',MAV_Labels_Class1vsRest(c1.training(i)));
    [CM_MAV, ~, TstAcc_MAV_C1rest(i), ~] = confusion(MAV_Labels_Class1vsRest(c1.test(i)), TstMAVFC1Rest);
    TotalCM_MAV_C1rest = TotalCM_MAV_C1rest + CM_MAV;
    
    % Class 1 vs Rest (VAR)
    [TstVARFC1Rest, TstVARErrC1Rest] = classify(VAR_Data_Class1vsRest(c2.test(i))', VAR_Data_Class1vsRest(c2.training(i))', VAR_Labels_Class1vsRest(c2.training(i)));
    [CM_VAR, ~, TstAcc_VAR_C1rest(i), ~] = confusion(VAR_Labels_Class1vsRest(c2.test(i)), TstVARFC1Rest);
    TotalCM_VAR_C1rest = TotalCM_VAR_C1rest + CM_VAR;
    
    % Class 1 vs Rest (MAV + VAR combined)
    [TstMAVVARFC1Rest, TstMAVVARErrC1Rest] = classify(MAVVAR_Data_Class1vsRest(:, c3.test(i))', MAVVAR_Data_Class1vsRest(:, c3.training(i))', MAVVAR_Labels_Class1vsRest(c3.training(i)));
    [CM_MAVVAR, ~, TstAcc_MAVVAR_C1rest(i), ~] = confusion(MAVVAR_Labels_Class1vsRest(c3.test(i)), TstMAVVARFC1Rest);
    TotalCM_MAVVAR_C1rest = TotalCM_MAVVAR_C1rest + CM_MAVVAR;
end

% Calculate average accuracies
Avg_Acc_MAV = mean(TstAcc_MAV_C1rest) ;
Avg_Acc_VAR = mean(TstAcc_VAR_C1rest) ;
Avg_Acc_MAVVAR = mean(TstAcc_MAVVAR_C1rest) ;

% Output final results
fprintf('\n=== Final Results ===\n\n');

fprintf('Combined Confusion Matrix for MAV (All Folds):\n');
disp(TotalCM_MAV_C1rest);
fprintf('Average Accuracy (MAV): %.2f%%\n\n', Avg_Acc_MAV);

fprintf('Combined Confusion Matrix for VAR (All Folds):\n');
disp(TotalCM_VAR_C1rest);
fprintf('Average Accuracy (VAR): %.2f%%\n\n', Avg_Acc_VAR);

fprintf('Combined Confusion Matrix for MAV+VAR (All Folds):\n');
disp(TotalCM_MAVVAR_C1rest);
fprintf('Average Accuracy (MAV+VAR): %.2f%%\n\n', Avg_Acc_MAVVAR);