function ConvertedNames = name2matrix(X)


% X is a cell of names 
ConvertedNames = [];

% columnsOfnames = 0;



for i = 1:length(X),
    columnsOfnames = size(ConvertedNames,2);
    GetName = X(i); % a 1x1 cell
    Namestr = cell2mat(GetName); % str
    Namestr = lower(Namestr);
%   Namelen = length(Namestr);
    [NameMatrix, columnOfMat] = Letter2Vec(Namestr);
%     [~,columnOfMat] = size(NameMatrix);
    ConvertedNames(:,columnsOfnames+1:columnsOfnames+columnOfMat) = NameMatrix; 
end




function [NameMatrix, columnOfMat]= Letter2Vec(Namestr)
    Alphabets = double(Namestr-'a'+1);
    Alphabets(Alphabets<1 | Alphabets>26) = [];
    Namelen = length(Alphabets); % how many letters 
    NameMatrix = zeros(27,Namelen); 
    for i = 1:Namelen,
        GetLetter = NameMatrix(:,i);
        GetLetter(Alphabets(i))=1;
        NameMatrix(:,i) = GetLetter;
    end
    NameMatrix = [ NameMatrix, [zeros(1,26),1]',[zeros(1,26),1]']; % add a space at the end
    columnOfMat = Namelen+2; % number of letters plus a space