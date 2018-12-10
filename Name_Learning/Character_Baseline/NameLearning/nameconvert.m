function names = nameconvert(X)

names =[];
m = 0;% initial row count;
space = [0 1 0 0 0 0 0];

for i=1:length(X),
    a_name = dec2bin(X{i},7); % dec2bin gives character array
    m_name = size(a_name,1);
    name_num = [];
    for rowcount = 1:m_name,
        for k=1:7,
            name_num(rowcount,k) = str2num(a_name(rowcount,k));
        end
    end
    name_num = [name_num; space];
    names(m+1:m+m_name+1,:) =name_num;
    m = size(names,1); % update number of rows 
end;