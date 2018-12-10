function write2txt(name)

fileID = fopen('names_output.txt','w');
fprintf(fileID,'%c',name);

fclose(fileID);
