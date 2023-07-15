%Author : H.Egemen Gulpinar
%BEIDOU - GPS - Galileo - GLONASS RINEX 3.02 - 3.03 - 3.04 NAV EPHEMERIS DATA CONVERTING & READING

function [ outputEphemeris] = readRinexNav( filePath )
%readRinexNav Reads a mixed RINEX navigation file *.rnx and returns satellite data

'Loading RINEX Data...'
endOfHeader = 0;


navFile = fopen(filePath);
count = 0;

%Read header
while (~endOfHeader)
    line = fgetl(navFile);
    lineSplit = strsplit(line);
    
    if strfind(line,'RINEX VERSION')
        Version_rinex = lineSplit(2);
        if (find(strcmp({'3.02','3.03','3.04'},Version_rinex))) == 0
            error 'Not the correct version, should be 3.02 | 3.03 | 3.04'
        end
        
        
    elseif strfind(line,'DATE')
        %IF THESE PARAMETERS NECESARRY, UNCOMMENT THE LINES 
  %----------------------------------------------------%
%         date = lineSplit(3);
%         year = str2mat(date{1,1}(1:4));
%         month = str2mat(date{1,1}(5:6));
        %day = str2mat(date{1,1}(7:8));
        %DOY=Date2DayOfYear(real(year),real(month),real(day));
%     elseif strfind(line,'IONOSPHERIC CORR')
%         if strcmp(lineSplit(1), 'GPSA')
%             ionoAlpha = str2mat(lineSplit(2:5));
%         elseif strcmp(lineSplit(1), 'GPSB')
%             ionoBeta = str2mat(lineSplit(2:5));
%         end
  %----------------------------------------------------%
    elseif strfind (line,'LEAP SECONDS')
        leapSeconds = str2mat(lineSplit(2));
    elseif strfind(line,'END OF HEADER')
        endOfHeader = 1;
    end
end

%ionosphericParameters = [ionoAlpha; ionoBeta];
%read body

%gpsEphemeris =  [];
%glonassEphemeris = [];
beidouEphemeris = [];

keplerArray = string(zeros(22,1)); %Vector containing Keplerian elements type ephemeris (GPS, Beidou, Galileo)
%cartesianArray = zeros(19,1); 

   
                %--------------------------
                
        function output = rinex_converter(lineSplit)  
            index_split = 1;
            temp_sort = 1;
            flag = 1;
            temp_rinex = [];
            result_split = [];
            cnt = 1;
            flag_conditions = 0;
            size_of_split = size(lineSplit);
            final_result = cell(1,4);
            for w=1:1
                if lineSplit ~= " "
                    %string(lineSplit(index_split))
                    lineSplit = string(lineSplit)
                    final_result = textscan(lineSplit(w),"%f32%f32%f32%f32")
                end
                output = final_result;
            end
        end

    %---------------------------------
while ~feof(navFile)    
    if line == -1
        break
    end
    if count == 5
        line_index = fgetl(navFile);
        count = 0;
    end

%-----------------------------
    try 
             line = fgetl(navFile);

          %   lineSplit = strsplit(line);
        line_size = size(line);

        %%Read All OF THE EPHEMERIS
       lineSplit = textscan(line,"%s %4d %d %d %d %d %2d %f%f%f");
      % textscan(line,"%c %d %4d %d %d %d %d %2d %f%f%f")

    if strcmp(lineSplit{1,1}{1,1},'C') %CONTROL PRN NUMBER ( C05 or C 5 PROBLEM FIX)
        svprn = lineSplit{2};
        year = string(lineSplit(3));
        month = string(lineSplit(4));
        day = string(lineSplit(5));
        hour = string(lineSplit(6));
        minute = string(lineSplit(7));
        second = string(lineSplit(8));

    else
   % try
        svprn = lineSplit{1};
        year = string(lineSplit(2));
        month = string(lineSplit(3));
        day = string(lineSplit(4));
        hour = string(lineSplit(5));
        minute = string(lineSplit(6));
        second = string(lineSplit(7));
    end

            line_index = fgetl(navFile);
            %lineSplit = strsplit(line_index);   
            size_of_split = size(lineSplit);
            %rinex_converter(lineSplit);
            lineSplit = rinex_converter(line_index);
            count = count + 1
            IODE = lineSplit{1};
            crs = lineSplit{2};
            deltan = lineSplit{3};
            M0 = lineSplit{4};

            %-----------------------
            line_index = fgetl(navFile);

           % lineSplit2 = strsplit(line_index);
            lineSplit2 = rinex_converter(line_index);
            count = count + 1
            cuc = lineSplit2{1};
            ecc = lineSplit2{2};
            cus = lineSplit2{3};
            roota = lineSplit2{4};

            %---------------------

            line_index = fgetl(navFile);

            %lineSplit = strsplit(line_index);
            lineSplit = rinex_converter(line_index);
            count = count + 1
            toe = lineSplit{1};
            cic = lineSplit{2};
            Omega0 = lineSplit{3};
            cis = lineSplit{4};

            %------------------------
            line_index = fgetl(navFile);

           % lineSplit = strsplit(line_index);
            lineSplit = rinex_converter(line_index);
            count = count + 1
            i0 =  lineSplit{1};
            crc = lineSplit{2};
            omega = lineSplit{3};
            Omegadot = lineSplit{4};

            %------------------------
            line_index = fgetl(navFile);

            %lineSplit = strsplit(line_index);
            lineSplit = rinex_converter(line_index);	
            count = count + 1    %
            idot = lineSplit{1};
            CodesOnL2 = lineSplit{2};
            week_toe = lineSplit{3};
            L2Pflag = lineSplit{4};

            line_index = fgetl(navFile);
    catch
               % break
display("RINEX Convertion Finished")

    end
            %Conversion to the format required by function

            keplerArray(1)  = string(svprn); 
            keplerArray(2) = string(year);
            keplerArray(3) = string(month);
            keplerArray(4) = string(day);
            keplerArray(5) = string(hour);
            keplerArray(6) = string(minute);
            keplerArray(7) = string(second);
            keplerArray(8)  = IODE;
            keplerArray(11)  = M0;
            keplerArray(15)  = roota;
            keplerArray(10)  = deltan;
            keplerArray(13)  = ecc;
            keplerArray(22)  = omega;
            keplerArray(12)  = cuc;
            keplerArray(14)  = cus;
            keplerArray(21) = crc;
            keplerArray(9) = crs;
            keplerArray(20) = (i0);
            keplerArray(24) = idot;
            keplerArray(17) = cic;
            keplerArray(19) = cis;
            keplerArray(18) = Omega0;
            keplerArray(23) = Omegadot;
            keplerArray(16) = toe;
                  
% ------------------------------------------------------------------------%
%-----------------------------FINAL RETURN OUTPUT-------------------------%
                    
                    beidouEphemeris =  [beidouEphemeris keplerArray];
               
    
end
% Construct output
%outputEphemeris.glonassEphemeris        = real(glonassEphemeris);
%outputEphemeris.gpsEphemeris            = real(gpsEphemeris);
outputEphemeris.beidouEphemeris         = beidouEphemeris;
%outputEphemeris.ionosphericParameters   = real(ionosphericParameters);
%outputEphemeris.leapSeconds             = real(leapSeconds);


fclose(navFile);
'Ephemeris loaded correctly'


end