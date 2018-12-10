function [avalanche, sigma] = CalcAvalanche(X)


% spike_num = sum(X);

% silenttime = find(spike_num==0);

% initial 
avalanche = [];
spike_in_burst = 0;

%% find avalanche sizes 
for time = 1:size(X,2),
    activity = X(:,time);% get NW activity at time t
    spike_num = sum(activity); % 
    if spike_num >0,
        spike_in_burst = spike_in_burst + spike_num;
    else 
        avalanche = [avalanche, spike_in_burst];
        spike_in_burst = 0; % clear 
    end
end
        
avalanche(avalanche ==0) = []; % remove the zeros in avalanche size count, if any 

%% calculate sigma 
XX = X; % make s copy of X
XX(:, sum(X)==0) = [];

spikecount = sum(XX); % count spikes of all spiking activity 
sigma = zeros(1,size(spikecount,2)-1);

for i = 2:size(spikecount,2),
    sigma(i-1) = spikecount(i)/spikecount(i-1); % branching process 
end







