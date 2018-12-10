function [X,W] = RNNlocalmemo(nodes, steps)


switch nargin
    case 0
        N = 256;
        time = 10000; %10k steps
    case 1
        N = nodes;
        time = 10000;
    otherwise
        N = nodes;
        time = steps;
end


%% generate random Gaussian signal 

input = 0.006*N*randn(N,time)-0.01*N; % 


%% Parameters
beta = 10;
gamma = 1e-5;
epsilon = 1e-3;


tau = 20;
taux = 10;
taum = 50;


%% Initial

%prob = zeros(N,time);% prob
prob = rand(N,1); %initial probability
X = zeros(N,time); % states
X(:,1) = binornd(1,prob); % initial states


% Filter state variables  
E_prob1 = rand(N,1);
E_prob2 = rand(N,1);
E_prob3 = rand(N,1);
% prob_R = zeros(N, 1);
% prob_N = zeros(N, 1);


E_prob4 = rand(N);
E_prob5 = rand(N);
E_prob6 = rand(N);

% initial W, dW
W = zeros(N);
% dW = rand(N);

%% Spiking Network 
for i = 2:time
    
    %% update network states
    
    xt_prev = X(:,i-1); % get the previous state xt-1
    vt = W*xt_prev + input(:,i); %current voltage vector
    prob = 0.4./( 1+exp(-2*beta*vt) ); % probability vector
    
    prob = max(prob,epsilon); prob = min(prob,1-epsilon);
    
    X(:,i) = binornd(1,prob); % current new state xt
    xt = X(:,i);
    %sigma(i) = sum(xt)/max(1,sum(xt1));
    
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
    %dW = dW*gamma*2*beta;
    W = W+dW;

    
end
