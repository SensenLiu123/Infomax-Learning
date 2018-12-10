function [X,W,dW] = RNNBCMTel(nodes, steps,offset,v0)


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


%% generate random telepgraph signal 


input = zeros(N, time);

for rowcount = 1:N, % N rows input
    period = floor(200*rand(1)) ;% get square wave period 
    singleperiod = [offset*N*ones(1,period),-offset*N*ones(1,period)];
    Rowinput = singleperiod;
    for repeat = 1:floor(time/period),
        Rowinput = [Rowinput, singleperiod];
    end
       
%     Rowinput  = repmat(singleperiod, [1, floor(time/period)] );
    input(rowcount,:) = Rowinput (1: time);
end


input = input + 0.006*N*randn(N,time);

%% Parameters
beta = 10;
gamma = 1e-5;
epsilon = 1e-3;


%% Initial


W = zeros(N);dW = zeros(N);
prob = rand(N,1);
Theta = zeros(N,1); % sliding threshold
tau = 10;


X = zeros(N,time); 
X(:,1) = binornd(1,prob); % initial states

%% network evolution
for i = 2:time
    %% update network states
    xt1 = X(:,i-1); % get the previous state xt-1
    vt = W*xt1+ input(:,i); %current voltage vector
    
    
    prob = 1./( 1+exp(-2*beta*vt) ); % probability vector
    prob = max(prob,epsilon); prob = min(prob,1-epsilon);
    
    X(:,i) = binornd(1,prob); % current new state xt
%     xt = X(:,i);
        
    %% update W
    Theta = ((tau-1)*Theta + 2*vt.^2)/tau;
    phi = vt.*(vt-Theta/v0);
    dW = gamma* (phi*xt1');
    W = W+dW;
end