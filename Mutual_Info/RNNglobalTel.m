function [X,P,W,dW] = RNNglobalTel(nodes,steps,offset)
% Binary-network-MOnteCarlo-estimation
% iid white input
% Fewer variables for less memory

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


%% Parameters

beta = 10;
gamma = 1e-5;
epsilon = 1e-3;


taum = 50;
% input = 0.006*N*randn(N,time)-0.011*N; % white noise 5 nodes
%% generate random telepgraph signal 


input = zeros(N, time);

for rowcount = 1:N, % N rows input
    period = floor(200*rand(1)) ;% get square wave period 
    singleperiod = [offset*N*ones(1,period),-offset*N*ones(1,period)];
    Rowinput = singleperiod;
    for repeat = 1:floor(time/period),
        Rowinput = [Rowinput, singleperiod];
        if length(Rowinput) >= time
            break;
        end
    end
       
%     Rowinput  = repmat(singleperiod, [1, floor(time/period)] );
    input(rowcount,:) = Rowinput (1: time);
end


input = input + 0.006*N*randn(N,time);



%% Initial

P = zeros(N,time);% prob
prob = rand(N,1); %initial probability
P(:,1) = prob;
X = zeros(N,time); % states
X(:,1) = binornd(1,prob); % initial states
%Mu_info = zeros(1,time);


% MOnte Carlo  variables  
    MCx_prev = zeros(N,2e3);
    MCvt = MCx_prev;
    MCprob = MCvt;
    MCE_prob5 = zeros(N,N,2e3);

    E_prob6 = rand(N);

% initial W, dW
W = zeros(N);
dW = rand(N);

%% Spiking Network 
for i = 2:time
    
    %% update network states
    
    xt_prev = X(:,i-1); % get the previous state xt-1
    vt = W*xt_prev + input(:,i); %current voltage vector
    
    prob = 1./( 1+exp(-2*beta*vt) ); % probability vector
    prob = max(prob,epsilon); prob = min(prob,1-epsilon);
    
    P(:,i) = prob;
    X(:,i) = binornd(1,prob); % current new state xt
    
    %% Monte Carlo estimate

    for MCtrial = 1:2e3,
        prob_prev = P(:,i-1);
        MCx_prev(:,MCtrial) = binornd(1,prob_prev); % previous x 
        MCvt(:,MCtrial) = W* MCx_prev(:,MCtrial) + input(:,i); % voltages
        MCprob(:,MCtrial) = 1./( 1+exp(-2*beta*MCvt(:,MCtrial)) ); % probability  
        MCE_prob5(:,:,MCtrial) = MCprob(:,MCtrial)*MCx_prev(:,MCtrial)'; % pi^t xj^t-1
    end
    
    MCx_current = binornd(1,MCprob);
    
    
    %% Expectations
    % new vector expectations
    E_prob1 = mean(MCprob,2); % E[p]
    E_prob2 = mean(MCprob.^2,2); % E[p^2]
    E_prob3 = mean(MCx_current,2); % E_x|X [xi^t]
    

    % log terms
    prob_R = (1-prob).*log( prob./E_prob1 ).*E_prob3; % (1-p)log(p/Ep)E_x|X [xi^t]
    prob_N = prob.*log( (1-prob)./(1-E_prob1)  ).*(1-E_prob3); % p log(1-p/1-Ep) (E_x|X [1-xi^t])
    
    % second moment terms
    V = E_prob2./E_prob1.*E_prob3 - (E_prob2 - E_prob1)./(1-E_prob1).*(1-E_prob3); % E[p^2]/E[p]E_x|X [xi^t] - (E[p^2]-E[p])/(1-E[p]) (E_x|X [1-xi^t])
    
    % new matrices
    E_prob4 =  V*mean(MCx_prev,2)'; %  matrix E[ V(i) xj^t-1]
    E_prob5 = mean(MCE_prob5,3); % matrix E[pi^t xj^t-1]
    E_prob6 = ( (taum-1)*E_prob6 + prob_R*xt_prev' - prob_N* xt_prev')/taum; % matrix E[log terms] 
    
    
    %% update W
    
    dW = gamma*2*beta*(E_prob4-E_prob5+ E_prob6);
    %dW = dW*gamma*2*beta;
    W = W+dW;
%     W = W.*Selfconn; % remove the self-connection, if any   
 
    
end





