%Author : H.Egemen Gulpinar
%BEIDOU - GPS - Galileo - GLONASS RINEX 3.02 - 3.03 - 3.04 NAV EPHEMERIS READING
%readRinexNav Reads a mixed RINEX navigation file *.nav and returns the rnx file data
%A random txt file include the rnx file names
function [lineSplit] = read_files( filePath )

'Loading BeiDou RINEX NAV Files'

new_file = strings();
navFile = fopen(filePath);
lineSplit = strings();
%Read header
i = 1;
j = 1;
while ~feof(navFile)
    
    line = fgetl(navFile);
    lineSplit(i,1) = line;
    i = i+1
end

fclose(navFile);
'BeiDou RINEX NAV FILES Reading SUCCESFULL'

end