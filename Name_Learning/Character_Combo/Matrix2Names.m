function Name = Matrix2Names(XX,fNameBank)

output = XX(end-8+1:end, :); % 
% output = XX(1:8, :); % 

Alphabet1 = lower('ABCDEFG');
Alphabet2 = lower('HIJKLM');
Alphabet3 = lower('NOPQR');
Alphabet4 = lower('STUV');
Alphabet5 = lower('WXY');
Alphabet6 = lower('Z ');
% Alphabet = lower('ABCDEFGHIJKLMNOPQRSTUVWXYZ ');

Vowel = ('aeiou');
Consonant = ('bcdfghlmnqv');
% Alphabet = lower('AB CD EF GH IJ KL MN O PQ RS TUV WX YZ ');

len = size(XX,2); % columns
helpindex = rand(1,len);
wcount = 0;
Name = [];

for i = 1:len, 
    
    LetterVec = output(:,i);
    
    if LetterVec(1)==1,
        LetterVec(1) = [];
        Letter = Alphabet1(LetterVec>0);
    elseif LetterVec(2)==1,
        LetterVec(1:2) = [];
        Letter = Alphabet2(LetterVec>0);
    elseif LetterVec(3)==1,
        LetterVec(1:3) = [];
        Letter = Alphabet3(LetterVec>0);
    elseif LetterVec(4)==1,
        LetterVec(1:4) = [];
        Letter = Alphabet4(LetterVec>0);
    elseif LetterVec(5)==1,
        LetterVec(1:5) = [];
        Letter = Alphabet5(LetterVec>0);
    elseif LetterVec(6)==1,
        LetterVec(1:6) = [];
        Letter = Alphabet6(LetterVec>0);
    else
        Letter = ' ';
%         pick = ceil(34*rand(1));
%         Letter = Alphabet(pick);
    end
    
    wcount = wcount+1;
    
    
    if i==1 || isequal (Name(end), ' '),
%         Letter = upper(Letter);
        wcount = 1;
    end
    
    
    if wcount>5,
        Letter = [Letter,' '];
    end
    
    
    Name = [Name,Letter];

    
    % double spaces
    if i>2 && isequal (Name(end), ' ') && isequal(Name(end-1), ' '),
        Name(end)=[];
    end   
    % double consonants
    if i>2 && ismember (Name(end), Consonant) && ismember(Name(end-1), Consonant),
        Name(end)=Vowel(ceil(5*rand(1)));
    end  
    % triple vowels
    if i>2 && ismember (Name(end), Vowel) && ismember(Name(end-1), Vowel) && ismember(Name(end-2), Vowel) ,
        Name(end-1)=Consonant(ceil(11*rand(1)));
    end
    % one isolated letter 
    if i>2 && isequal (Name(end), ' ') && isequal(Name(end-2), ' '),
        Name(end-1:end)=[];
    end  
    % two letters 
    if i>4 && isequal (Name(end), ' ') && isequal(Name(end-3), ' '),
        Name(end-2:end)=[];
    end
    % insert some names
    if isequal (Name(end), ' ') && helpindex(i)>0.9
            Namehelp = fNameBank (ceil(rand(1)*13e3));
            Namehelp = char(Namehelp);
            Name = [Name,lower(Namehelp),' '];
    end
        

end
%%
% for i=1:lenth,
%     Letter = Alphabet(output(:,i)>0);
%     wcount = wcount+1;
%     %%
%     if i==1 || isequal (Name(end), ' '),
%         Letter = upper(Letter);
%         wcount = 1;
%     end
%     
%     if wcount>9,
%         Letter = [Letter,' '];
%     end
%     Name = [Name,Letter];
% end
%     
