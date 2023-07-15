function [lineSplit] = read_BeiDou_Constellation( filePath )
%READ BEIDOU CONSTELLATION INFORMATION .TXT FILE 

'Loading BeiDou ConstellationStatus'

navFile = fopen(filePath);
lineSplit = strings();
%Read header
i = 1;
j = 1;
while ~feof(navFile)
    
    line = fgetl(navFile);
    split_word = strsplit(line)
    for k=1:4
         lineSplit(j,i) = split_word(k)
         i = i+1;
    end
    i = 1;
   j = j+1;
    
end

fclose(navFile);
'BeiDou ConstellationStatus Loaded Correctly'

end