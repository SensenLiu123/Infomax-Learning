function [mulinf]= MIBCMruleNWs

mulinf = zeros(20,1);

for NWsize =  5: 5: 100,
%     for offset = 0:0.001:0.011,
        [X,~,~] = RNNBCM(NWsize,6e3,1);
        MI = zeros(1,1e3);
        for count = 1:1e3,
            a = X(:,count+2000:2999+count);
            b = X(:,count+2001:3e3+count);
            MI(count) = mi(a',b'); 
        end
    mulinf (floor(NWsize/5)) = mean(MI);
%     end
end


