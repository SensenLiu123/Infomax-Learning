function [XX,P] = RNNTrainedCharMidLayer(W,X,time)

%% initial


[numnode]= size(W,1);

% time = rep*patternnum;
XX = zeros(numnode,time); % 
P = zeros(numnode, time);

col = round(size(X,2)*rand(1));
XX(:,1) = X(:,col);
% inputnodeprob = repmat(patternprob, 1, rep);


%% para
beta = 10;

%% training
for i = 2:time
    
    %% update network states    
    xt_prev = XX(:,i-1); % get the previous state xt-1
%     prob = inputnodeprob(:,i);
    vt = W*xt_prev;
    vt = vt-mean(vt);
    prob = 1./( 1+exp(-2*beta*vt) ); 
    P(:,i) = prob;
    xt =  binornd(1,prob);
    xt = realization(xt,xt_prev,prob);
%     xt = prob>0.5;
%     xt = binornd(1,prob); % current new state xt
%     xt(3:4)=correctdecision(prob);
    XX(:,i)=xt;
 end



    function xt = realization(xt,xt_prev,prob)
        
%         xt(28:81) = prob(28:81)>0.5;
        xt(1:27) = xt_prev(end-27+1:end); xt(82:end) = 0;
        [~,i2] = max(prob(end-27+1:end));
        xt(i2+27*3) = 1;
        
