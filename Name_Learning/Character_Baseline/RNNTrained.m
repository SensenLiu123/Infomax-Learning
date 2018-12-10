function [X,P] = RNNTrained(W,time,initial)
%% demo
% 3 nodes


%% initial


[numnode]= size(W,1);

% time = rep*patternnum;
X = zeros(numnode,time); % 
P = zeros(numnode, time);
X(:,1) = initial;
% inputnodeprob = repmat(patternprob, 1, rep);


%% para
beta = 8;

%% training
for i = 2:time
    
    %% update network states    
    xt_prev = X(:,i-1); % get the previous state xt-1
%     prob = inputnodeprob(:,i);
    vt = W*xt_prev;
    prob = 1./( 1+exp(-2*beta*vt) ); 
    P(:,i) = prob;
    xt = prob>0.5;
%     xt = binornd(1,prob); % current new state xt
%     xt(3:4)=correctdecision(prob);
    X(:,i)=xt;
 end



