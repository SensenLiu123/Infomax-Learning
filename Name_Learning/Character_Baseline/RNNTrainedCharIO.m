function [XX,P] = RNNTrainedCharIO(W,time,X)

[numnode]= size(W,1);

XX = zeros(numnode,time);
col = round(size(X,2)*rand(1));
XX(:,1) = X(:,col);
XX(:,2) = X(:,col+1);
XX(:,3) = X(:,col+2);
P = zeros(numnode, time);
% initialprob = rand(1,numnode);
% inputnodeprob = repmat(patternprob, 1, rep);


%% para
beta = 10;

%% testing
for i = 4:time
    
    %% update network states    
    xt_prev = XX(:,i-1); % get the previous state xt-1
    
%     prob = inputnodeprob(:,i);
    vt = W*xt_prev;
    prob = 1./( 1+exp(-2*beta*vt) ); 
    P(:,i) = prob;
%     xt = prob>0.5;
    xt = realization(prob,xt_prev,XX(:,i-2),XX(:,i-3));

    XX(:,i)=xt;
 end



    function xt = realization(prob,xt_prev,xt_pre2,xt_pre3)
        xt = zeros(27*4,1);
%         [~,i1] = max(prob(1:27));
%         [~,i2] = max(prob(28:54));
%         [~,i3] = max(prob(55:27*3));
        [~,i4] = max(prob(end-27+1:end)); % output
        xt(i4+27*3) = 1;
        xt(27*2+1:27*3) = xt_prev(end-27+1:end); % update the previous step
        xt(27*1+1:27*2) = xt_pre2(end-27+1:end); 
        xt(1:27) = xt_pre3(end-27+1:end); 
