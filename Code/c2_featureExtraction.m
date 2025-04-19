
filteredSignal = filteredSignal_filt; % bandapass filtered signal 
label = labels; % labels of stimulus locations

% WSize = 0.3; % window size in s 0.05(50ms), 0.1(100ms), 0.3(300ms)
% Olap = 0; % overlap percentage (0, 0.25, 0.75)

WSizeSec_list = [0.05, 0.1, 0.3];  % in seconds (50ms, 100ms, 300ms)
Olap_list= [0, 0.25, 0.75]; % overlap ratios

%% Extracting Features over overlapping windows

% WSize = floor(WSize*fs);	    % length of each data frame, 30ms
% nOlap = floor(Olap*WSize);  % overlap of successive frames, half of WSize
% hop = WSize-nOlap;	    % amount to advance for next data frame
% nx = length(filteredSignal);	            % length of input vector
% len = fix((nx - (WSize-hop))/hop);	%length of output vector = total frames

% % preallocate outputs for speed
% [MAV_feature, VAR_feature, featureLabels] = deal(zeros(1,len));

Rise1 = gettrigger(label,0.5); % gets the starting points of stimulations
Fall1 = gettrigger(-label,-0.5); % gets the ending points of stimulations
fs=20000;
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

        % preallocate outputs for speed
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
           
        timeFeat=((0:len-1)*hop + (WSize/2))/fs; %change to time scale (datapoints/freq)
        subplot(length(WSizeSec_list),length(Olap_list),subIndex);
        hold on; grid on;

        p1=plot(timeFeat, MAV_feature, 'b-','LineWidth',1.5);
        p2=plot(timeFeat, VAR_feature, ' r-','LineWidth',1.5);
        
        
        
        set(gca, 'YScale', 'log');

        xlabel('times (sec)');
        ylabel('Amplitude (uV)');
        title(sprintf('Wsize = %.2f sec, Olap=%.2f',WSize_sec,Olap));
        
        legend([p1,p2],{'MAV','VAR'}, 'Location','best');

        yMin = min([MAV_feature, VAR_feature]) * 0.9;
        yMax = max([MAV_feature, VAR_feature]) * 1.1;
        
        sgtitle('MAV and VAR Features: Flex') %total title

        for k = 1:length(Rise1)
            x1 = Rise1(k) / fs;
            x2 = Fall1(k) / fs;
            p3=patch([x1 x2 x2 x1], [yMin yMin yMax yMax], ...
                  'g', 'FaceAlpha', 0.15, 'EdgeColor','none','HandleVisibility','Off');

            
        end

        legend([p1,p2,p3],{'MAV','VAR','Stimulation'}, 'Location','east');
        
        hold off;

        subIndex = subIndex + 1;

    end

end



