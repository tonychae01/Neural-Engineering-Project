
close all; clc;


subj1_data=load('subj1.mat');
subj2_data=load('subj2.mat');

%% Pseudo code
% 1. 우선, 각 run 당 accuracy를 저장할 array생성 online 당 2D array (3개) 즉, [6*3 행렬]
% 2. 각 Run 당, 20 개의  trial 존재. --> Hit 개수/ Hit+Miss 개수 측정하여서 배열에 저장. 
% 3. 배열 반환 

% Miss개수를 count 하는 똑똑한방법: 참고
% start_codes = [7691, 7701];
% end_codes   = [7692, 7702];
% 
% is_start = ismember(hyp(1:end-1), start_codes);
% is_end   = ismember(hyp(2:end), end_codes);
% 
% valid_pairs = find(is_start & is_end);
% dt = (pos(valid_pairs + 1) - pos(valid_pairs)) / 512;  % fs = 512
% 
% timeout_count = sum(dt >= 7);

subj1_total_acc = createArray(6,3); % create arrary to save 6 online, 3 acc 
subj1_total_timeout = createArray(6,3); % for saving timeout

for i=1:6 % total 6 online session
    for j=1:3 % total 3 runs in session
        hyp=subj1_data.subj1.online(i).run(j).header.triggers.TYP;
        pos=subj1_data.subj1.online(i).run(j).header.triggers.POS;
        run_timeout=0;
        for k=1:length(hyp) % 1개의 run 내에서 timeout 개수 구하기!
            if (hyp(k)==7691 && hyp(k+1) == 7692) || (hyp(k)==7701 && hyp(k+1)==7702)
                if (pos(k+1)-pos(k))/512 >= 7 %over 7 sec
                    run_timeout = run_timeout+ 1;
                end
            end
        end

        run_hit=sum(hyp==7693)+sum(hyp==7703);

        run_miss=20-run_hit-run_timeout;

        run_acc = run_hit/(run_hit+run_miss);
        run_timeout_ratio = run_timeout/20;

        disp("run_acc: ")
        disp(run_acc) % matlab print
        disp("run_timeout: ")
        disp(run_timeout) % matlab print
        subj1_total_acc(i,j)=run_acc;
        subj1_total_timeout(i,j)=run_timeout_ratio;
    end
end

subj2_total_acc = createArray(6,3); % create arrary to save 6 online, 3 acc 
subj2_total_timeout = createArray(6,3); % for saving timeout

for i=1:6 % total 6 online session
    for j=1:3 % total 3 runs in session
        hyp=subj2_data.subj2.online(i).run(j).header.triggers.TYP;
        pos=subj2_data.subj2.online(i).run(j).header.triggers.POS;
        run_timeout=0;
        for k=1:length(hyp) % 1개의 run 내에서 timeout 개수 구하기!
            if (hyp(k)==7691 && hyp(k+1) == 7692) || (hyp(k)==7701 && hyp(k+1)==7702)
                if (pos(k+1)-pos(k))/512 >= 7 %over 7 sec
                    run_timeout = run_timeout+ 1;
                end
            end
        end

        run_hit=sum(hyp==7693)+sum(hyp==7703);

        run_miss=20-run_hit-run_timeout;

        run_acc = run_hit/(run_hit+run_miss);
        run_timeout_ratio = run_timeout/20;

        disp("run_acc: ")
        disp(run_acc) % matlab print
        disp("run_timeout: ")
        disp(run_timeout) % matlab print
        subj2_total_acc(i,j)=run_acc;
        subj2_total_timeout(i,j)=run_timeout_ratio;
    end
end
%save("subj2_total_acc.mat","subj2_total_acc");

%% Task 1.1
% subject
% plot accuracy over 6 session. (average accross runs/each subject)
% same with task 1.2

X = 1:6;

% Subject 1
y_1 = mean(subj1_total_acc, 2);    % [6 x 1]
std_1 = std(subj1_total_acc, 0, 2); % [6 x 1]

% Subject 2
y_2 = mean(subj2_total_acc, 2);
std_2 = std(subj2_total_acc, 0, 2);

% Combine into matrices
Y = [y_1, y_2];      % [6 x 2]
STD = [std_1, std_2];% [6 x 2]

% Create the bar plot and store handle
figure;
hb = bar(X, Y);  % 'hb' is a group of bar objects
hold on;

% Add error bars
for k = 1:2  % loop over subjects
    % Get correct x positions for each subject
    xpos = hb(k).XEndPoints;  % X coordinate for bar tip vectors!
    errorbar(xpos, Y(:,k), STD(:,k), 'k.', 'LineWidth', 1.5);
end

% Customize plot
xlabel('Online Session');
ylabel('Accuracy');
title('Subject-wise Accuracy Across 6 Sessions');
legend('Subject 1', 'Subject 2');
grid on;
hold off;

%% Time out plot for subject 1 & 2
X = 1:6;

% Subject 1
y_1 = mean(subj1_total_timeout, 2);    % [6 x 1]
std_1 = std(subj1_total_timeout, 0, 2); % [6 x 1]

% Subject 2
y_2 = mean(subj2_total_timeout, 2);
std_2 = std(subj2_total_timeout, 0, 2);

% Combine into matrices
Y = [y_1, y_2];      % [6 x 2]
STD = [std_1, std_2];% [6 x 2]

% Create the bar plot and store handle
figure;
hb = bar(X, Y);  % 'hb' is a group of bar objects
hold on;

% Add error bars
for k = 1:2  % loop over subjects
    % Get correct x positions for each subject
    xpos = hb(k).XEndPoints;  % X coordinate for bar tip vectors!
    errorbar(xpos, Y(:,k), STD(:,k), 'k.', 'LineWidth', 1.5);
end

% Customize plot
xlabel('Online Session');
ylabel('Timout Ratio');
title('Subject-wise Timeout Across 6 Sessions');
legend('Subject 1', 'Subject 2');
grid on;
hold off;

%% Task 1.2
% Perform Statistical Analysis for the trend: Linear Regression
% trend accuracy in group level
% trend accuracy in each subject 
% Adjusted R value, p-value

% Example data (replace with your actual data)
x = repelem((1:6),3);

y_1 = subj1_total_timeout'; %mean vector of subj1 %change to subj2_total_acc if you want
y_1=y_1(:); %Flatten the matrix to vector


% Perform linear regression
lm_1 = fitlm(x, y_1);

% Display regression results
disp(lm_1);

% Extract p-value and R-squared value
pValue = lm_1.Coefficients.pValue(2); % p-value for the slope coefficient (index 2)
rSquared = lm_1.Rsquared.Ordinary;    % R-squared value

% Display p-value and R-squared
disp(['P-value: ', num2str(pValue)]);
disp(['R-squared: ', num2str(rSquared)]);

%% subject 2
% x = (1:6);
x= [1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6];
% x = repelem(x, 3); %this also works...

% y_2 = mean(subj2_total_acc,2); %mean vector of subj1
y_2 = subj2_total_timeout'; %change to subj2_total_acc if you want
y_2=y_2(:);


% Perform linear regression
lm_2 = fitlm(x, y_2);

% Display regression results
disp(lm_2);

% Extract p-value and R-squared value
pValue = lm_2.Coefficients.pValue(2); % p-value for the slope coefficient (index 2)
rSquared = lm_2.Rsquared.Ordinary;    % R-squared value

% Display p-value and R-squared
disp(['P-value: ', num2str(pValue)]);
disp(['R-squared: ', num2str(rSquared)]);

%% Plot for the scatter + linear Regression:

%subject 1
scatter(x,y_1,'filled');

hold on;
line_x=linspace(min(x),max(x),100);
line_y=lm_1.predict(line_x');

plot(line_x,line_y,'r','LineWidth',2);
legend('Data Points (Run)'  , 'Linear Fit');
xlabel('Online Session');
xticks((1:6));
% 
% ylabel('Accuracy');
% title('Subject 1 Accuracy Statistical Trend');
ylabel('Timeout');
ylim(0:1);
title('Subject 1 Timeout Statistical Trend');

hold off;

%% Plot for the scatter + linear Regression:

%subject 2
scatter(x,y_2,'filled');

hold on;
line_x=linspace(min(x),max(x),100);
line_y=lm_2.predict(line_x');

plot(line_x,line_y,'r','LineWidth',2);

legend('Data Points (Run)'  , 'Linear Fit');
xlabel('Online Session');
xticks((1:6));
% ylabel('Accuracy');
% title('Subject 2 Accuracy Statistical Trend');

ylabel('Timeout');
title('Subject 2 Timeout Statistical Trend');

hold off;

%% Subject 1 & Subject 2 Group Level Trend - Accuracy
x_group_s = repelem((1:6),3)'; %repeat 6 times
x_group = [x_group_s' , x_group_s'];
y_group = [y_1' , y_2'];
lm_group = fitlm(x_group, y_group);

% Display regression results
disp(lm_group);

% Extract p-value and R-squared value
pValue = lm_group.Coefficients.pValue(2); % p-value for the slope coefficient (index 2)
rSquared = lm_group.Rsquared.Ordinary;    % R-squared value

% Display p-value and R-squared
disp(['P-value: ', num2str(pValue)]);
disp(['R-squared: ', num2str(rSquared)]);

%% Plot for the scatter + linear Regression:
scatter(x_group,y_group,'filled');

hold on;
line_x=linspace(min(x_group),max(x_group),100);
line_y=lm_group.predict(line_x');

plot(line_x,line_y,'r','LineWidth',2);
legend('Data Points (Run)'  , 'Linear Fit');
xlabel('Online Session');
xticks((1:6));

% ylabel('Accuracy');
% title('Group Accuracy Statistical Trend');
ylabel('Timeout');
title('Group Timeout Statistical Trend');

hold off;
 
%% Task 1.3
% Peform statistical testing to compare accuracy values at any given
% onlines session to the values in the first online session. 
% Pair-t test & p-value
%% Task 1.3 - Statistical Testing & Plotting

% Combine subject data: [6 sessions x 6 runs] matrix
total_acc = [subj1_total_acc, subj2_total_acc];  % size: [6 x 6]
% total_acc = [subj1_total_timeout, subj2_total_timeout];  % size: [6 x 6]

% Initialize for p-values
p_values = zeros(1,6);

% Perform paired t-test (session i vs session 1)
for i = 1:6
    pair_x = total_acc(1,:);   % session 1
    pair_y = total_acc(i,:);   % session i

    [h, p] = ttest(pair_x, pair_y);
    p_values(i) = p;
    
    fprintf("Session %d vs Session 1: p = %.4f\n", i, p);
end

%% Plot IQR (Boxplot) with scatter and p-values

figure;
boxplot(total_acc', 'Labels', {'1','2','3','4','5','6'});
hold on;

% Scatter points
for i = 1:6
    scatter(ones(1, size(total_acc,2)) * i, total_acc(i,:), 40, 'filled'); %same vector --> same color in plot
end

% Add p-values above each box
y_max = max(total_acc(:)) + 0.05;
text(1, y_max, sprintf("p=NaN"), 'HorizontalAlignment', 'center', 'FontSize', 10);
for i = 2:6
    if p_values(i)<0.05
        text(i, y_max, sprintf("p=%.3f", p_values(i)), 'HorizontalAlignment', 'center', 'FontSize', 10,'fontweight', 'bold');
    else 
    text(i, y_max, sprintf("p=%.3f", p_values(i)), 'HorizontalAlignment', 'center', 'FontSize', 10);
    end
end

xlabel('Online Session');
ylabel('Accuracy');
% ylabel('Timeout');
title('Paired t-test: Session i vs Session 1');
ylim([0, 1.1]);
grid on;
hold off;