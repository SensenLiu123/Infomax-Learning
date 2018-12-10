function [X,W,dWNorm] = RNNCharFFLayersTrain8bit(namelist, rep)


patternprob = max(0.01,namelist);patternprob = min(0.99, patternprob);

[numnode, patternnum]= size(patternprob);

numnode = numnode*10;%1 input  and 1 output, 64 middle layer % DC = 0.159
% numnode = numnode*16;%1 input  and 1 output, 112 middle layer  % DC = 0.199

time = rep*patternnum;
X = zeros(numnode,time); % 


% input = repmat(pattern, 1, rep);
inputnodeprob = repmat(patternprob, 1, rep);


E_prob1 = rand(numnode,1);
E_prob2 = rand(numnode,1);
E_prob3 = rand(numnode,1);

E_prob4 = rand(numnode);
E_prob5 = rand(numnode);
E_prob6 = rand(numnode);



W = zeros(numnode);
% dW = zeros(numnode);
dWNorm = zeros(1,time-1);

%% para
beta = 10;
gamma = 5e-6;
tau = 20; taux = 10; taum= 90;

%% training

for i = 2:time-1
    
    %% update network states
    
    xt_prev = X(:,i-1); % get the previous state xt-1
    vt = W*xt_prev-0.159;
%     vt(end-8+1:end) = vt(end-8+1:end)-6;
    prob = 1./( 1+exp(-2*beta*vt) );   
    prob(1:8) = inputnodeprob(:,i);
    
    prob(end-8+1:end) = inputnodeprob(:,i+1);
%     xt = prob>0.5;
    xt =  binornd(1,prob); % current new state xt
%     xt(3:4)=correctdecision(prob);
    X(:,i)=xt;
    
    %% Recursive filter 
    
    % new vector expectations
    E_prob1= ( (tau-1)*E_prob1 + prob )/tau; % E[p]
    E_prob2= ( (tau-1)*E_prob2 + prob.^2 )/tau; % E[p^2]
    E_prob3= ( (taux-1)*E_prob3 + xt.*prob )/taux; % E_x|X [xi^t]
    
    % log terms
    prob_R = (1-prob).*log( prob./E_prob1 ).*E_prob3; % (1-p)log(p/Ep)E_x|X [xi^t]
    prob_N = prob.*log( (1-prob)./(1-E_prob1)  ).*(1-E_prob3); % p log(1-p/1-Ep) (E_x|X [1-xi^t])
    
    % second moment terms
    V = E_prob2./E_prob1.*E_prob3 - (E_prob2 - E_prob1)./(1-E_prob1).*(1-E_prob3); % E[p^2]/E[p]E_x|X [xi^t] - (E[p^2]-E[p])/(1-E[p]) (E_x|X [1-xi^t])
    
    % new matrices
    E_prob4 = ( (taum-1)*E_prob4 + V*xt_prev')/taum; %  matrix E[ V(i) xj^t-1]
    E_prob5 = ( (taum-1)*E_prob5 + (prob)*xt_prev')/taum; % matrix E[pi^t xj^t-1]
    E_prob6 = ( (taum-1)*E_prob6 + prob_R*xt_prev' - prob_N* xt_prev')/taum; % matrix E[log terms] 
      
    %% update W
    
    dW = gamma*2*beta*(E_prob4-E_prob5+ E_prob6);
    dWNorm(i-1)=norm(dW);
    W = W+dW;
%     W = normr(W);
end

% 

