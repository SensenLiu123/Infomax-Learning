function [X,XX,P,W,dWNorm] = RNNUnsupTrain(rep)
%% demo
% Input is:
% 1 0 0 1
% 0 1 1 0
% 0 0 0 0
% 0 0 0 0
% repeat 

%% initial
% pattern = [1 0 0 1; 0 1 1 0; 0 0 0 0; 0 0 0 0]; 
patternprob = [.99 0.01 0.01 .99; 0.01 .99 .99 0.01];
time = rep*4;
X = zeros(4,time); % 
P = zeros(4,time);
X(:,1) = [1;0;1;1];
% input = repmat(pattern, 1, rep);
inputnodeprob = repmat(patternprob, 1, rep);


E_prob1 = rand(4,1);
E_prob2 = rand(4,1);
E_prob3 = rand(4,1);
prob_R = zeros(4, 1);
prob_N = zeros(4, 1);
E_prob4 = rand(4);
E_prob5 = rand(4);
E_prob6 = rand(4);




W = zeros(4);
dW = zeros(4);
dWNorm = zeros(1,time-1);




%% para
beta = 8;
gamma = 1e-5;
tau = 100;taux = 90;

%% training

for i = 2:time
    
    %% update network states
    
    xt_prev = X(:,i-1); % get the previous state xt-1
    vt = W*xt_prev; %current voltage vector
    prob = 1./( 1+exp(-2*beta*vt) );   
    prob(1:2) = inputnodeprob(:,i);    
    P(:,i) = prob;
    xt = binornd(1,prob); % current new state xt
    xt(3:4)=correctdecision(prob);
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
    E_prob4 = ( (tau-1)*E_prob4 + V*xt_prev')/tau; %  matrix E[ V(i) xj^t-1]
    E_prob5 = ( (tau-1)*E_prob5 + (prob)*xt_prev')/tau; % matrix E[pi^t xj^t-1]
    E_prob6 = ( (tau-1)*E_prob6 + prob_R*xt_prev' - prob_N* xt_prev')/tau; % matrix E[log terms] 
      
    %% update W
    
    dW = gamma*2*beta*(E_prob4-E_prob5+ E_prob6);
    dWNorm(i-1)=norm(dW);
    W = W+dW;
end



XX = X;
sequence = sign(P(3,:) - P(4,:));
base1 = zeros(2,time);
base2 = base1;
base1(:,sequence<0)= 1;
base2(:,sequence>0)= 1;
XX(3:4,:) = base1.*repmat([0;1], 1, time)+base2.*repmat([1;0], 1, time);

function x34=correctdecision(prob)

e = prob(3)-prob(4);

x34 = [0;1]*(e<0) + [1;0]* (e>0);

