function Nameoutput = Matrix2NamesIO(X)


output1 = X(1:27,:);
output2 = X(28:54,:);
output3 = X(55:27*3,:);
output4 = X(end-27+1:end, :); % 

% Output = X(55:81, :); % get output

lenth = size(X,2); % columns

Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ';


Name1 = [];Name2 = [];Name3 = [];Name4=[];


for i=1:lenth,
    Letter1 = Alphabet(output1(:,i)>0);
    Letter2 = Alphabet(output2(:,i)>0);
    Letter3 = Alphabet(output3(:,i)>0);
    Letter4 = Alphabet(output4(:,i)>0);
    Name1 = [Name1,Letter1];
    Name2 = [Name2,Letter2];
    Name3 = [Name3,Letter3];
    Name4 = [Name4,Letter4];
end
    
    Nameoutput = [Name1;Name2;Name3;Name4];
