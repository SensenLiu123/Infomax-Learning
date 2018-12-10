function Name = Matrix2NamesMid(X)

output = X(end-27+1:end, :); % 

% Output = X(55:81, :); % get output

lenth = size(X,2); % columns

Alphabet = lower('ABCDEFGHIJKLMNOPQRSTUVWXYZ ');

Name = [];
wcount = 0;
%%
for i=1:lenth,
    Letter = Alphabet(output(:,i)>0);
    wcount = wcount+1;
    %%
    if i==1 || isequal (Name(end), ' '),
        Letter = upper(Letter);
        wcount = 1;
    end
    
    if wcount>9, % in case for unbroken super long name string!
        Letter = [Letter,' '];
    end
    Name = [Name,Letter];
end
    
