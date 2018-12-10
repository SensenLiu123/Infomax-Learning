function [XX,P] = RNNTrainedCharMidLayer8bit(W,X,time)

%% initial


[numnode]= size(W,1);

% time = rep*patternnum;
XX = zeros(numnode,time); % 
P = zeros(numnode, time);


col = ceil(size(X,2)*rand(1));
XX(:,1) = X(:,col);
% inputnodeprob = repmat(patternprob, 1, rep);


%% para
beta = 10;

%% training
for i = 2:time
    
    %% update network states    
    xt_prev = XX(:,i-1); % get the previous state xt-1
    %     prob = inputnodeprob(:,i);
    vt = W*xt_prev-0.16;
%     vt = vt - mean(vt);
    vt(end-8+1:end) = vt(end-8+1:end)-4.2;
    prob = 1./( 1+exp(-2*beta*vt) ); 
    P(:,i) = prob;
    xt =  binornd(1,prob);
    [xt] = realization(xt,xt_prev,prob,X);
%     xt = prob>0.5;
%     xt = binornd(1,prob); % current new state xt
%     xt(3:4)=correctdecision(prob);
    XX(:,i)=xt;
 end



    function [xt] = realization(xt,xt_prev,prob,X)
                   
%         if sum(prob(end-8+1:end))>7
        prob(end-8+1:end) = prob(end-8+1:end)-mean(prob(end-8+1:end));
%         else 
        xt(1:8) = xt_prev(end-8+1:end); % take the previous letter as input 
        xt(end-8+1:end) = 0;% new letter     
        [~,I] = sort(prob(end-8+1:end));
        xt(end-8+I(end)) = 1;
        xt(end-8+I(end-1)) = 1;
%         end



        if xt_prev(end)==1 && xt_prev(end-2)==1
            res = ceil(size(X,2)*rand(1));
            xt = X(:,res);
        end

       % if previous output is 00000011
        if xt_prev(end)==1 && xt_prev(end-1)==1
            res = ceil(size(X,2)*rand(1));
            xt = X(:,res);
        end

