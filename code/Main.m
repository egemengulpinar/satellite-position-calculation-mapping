%Author : Egemen Gulpınar
%BEIDOU SATELLITE POSITION CALCULATION AND MAPPING ON WORLD MAP
%ONLY MEO AND IGSO SATELLITE POSITION CALCULATION & MAPPING WORKS CORRECTLY
%GEO SATTELITES HAVE PARTIALLY SAME LONGITUDE-LATITUDE-ALTITUDE DEGREES.

[data_name] = read_files('files_name.txt'); %READING TXT FILE WHO INCLUDE THE .rnx FILES
flag_world = 0;
h1 = [];
h2 = [];
counter = 1;
for index_of_data=1:12 %% number of rnx files. It should to be [1:number_of_rnx_files] <-- size(files_name)
    [datas] = readRinexNav(data_name(index_of_data));
    beidou_datas = datas.beidouEphemeris;
    [Longitud, Latitud,Altitude, name,esec,Satelitesinfo]= computeposition (beidou_datas);
    %READING BEIDOU CONSTELLATION INFO .TXT DATA.
    [Beidou_Constellation] = read_BeiDou_Constellation("BeiDouConstellationStatus.txt");
    A= 255*zeros(65,65,1,'uint8');% Or use your current marker You can also use geographic coordinates 
    satellite_size = size(Satelitesinfo,1);
    iconDir = fullfile('');
    iconFilename = fullfile(iconDir,'satellite.png'); %Every iteration, creating new png file for labelling satellite PRN 
    description_lat = cell(1,satellite_size);
    description_lon = cell(1,satellite_size);
    description_last = cell(1,satellite_size);
    e = wgs84Ellipsoid;  
    pnr_no_sat = strings();
    j = 1;
    flag  = 0;
    sat_date = string();
    position = [23 373;35 185;77 107]; 
    if(flag_world ==0)
        wm = webmap('World Imagery');
    end
    
      for i = 1:satellite_size     
        %try 
        % SATELLITE PRN BLANK ISSUE FIX
         if ~contains(name(i),'C')
             if str2num(name(i)) <10
             name(i) = strcat('C0',name(i))
             else
             name(i) = strcat('C',name(i))
             end
         end
         satellite_info = strfind(Beidou_Constellation,name(i));  %MATCH THE PRN WITH BEIDOU CONSTELLATION INFO .TXT DATA
         description_lat{:,i} = strcat("Latitude : ",mat2str(sprintf('%.5f',Latitud(i))));
         description_lon{:,i} = strcat(" Longitude : " ,mat2str(sprintf('%.5f',Longitud(i))));
         index_cons = find(strcmp(name(i),(str2mat(Beidou_Constellation(:,1)))))%MATCH THE PRN WITH BEIDOU CONSTELLATION INFO .TXT DATA
         sat_datetime(i) = strcat(beidou_datas(2),".", beidou_datas(3),".", beidou_datas(4),".",beidou_datas(5),".",beidou_datas(6),".",beidou_datas(7))
         description_last{:,i} =  strcat(description_lat{:,i},"  |  ", description_lon{:,i}, "  |  ", " Altitude : ", mat2str(sprintf('%.1f',Altitude(i))) ,"  |  "," Sat. Name : ", str2mat(Beidou_Constellation(index_cons,2)),"  |  ",  " Sat. Date : ", ...
         str2mat(sat_datetime(i)), "  |  ", " Sat. Type : ", str2mat(Beidou_Constellation(index_cons,4)));
      end      

    for k=1:satellite_size

        %CREATING SATELLITE LABEL PICTURES 
        RGB = insertText(A,[-5,5],name(k),'FontSize',30,'TextColor','black','BoxColor','yellow','Font','Arial Black'); 
        sat_label = strcat('testfile',string(k),'.png')
        pnr_no_sat(1,k) = sat_label
        imwrite(RGB,sat_label)

    end
     flag = flag+1
         %WMMARKER PARAMETERS AND ICON DIRECTORY PATH
         h1 = wmmarker(Latitud,Longitud,'Description',description_last, ...
                         'FeatureName',name, ... 
                         'Icon',iconFilename, ... 
                         'OverlayName',name(i))        
         for q=1:satellite_size
             %LITTLE DIFFERENT LON AND LAT DEGREES FOR LABELS TO APPEAR
             Latitud(q) = Latitud(q) - 3 
             Longitud(q) = Longitud(q) -3.5 
             end
         h2 = wmmarker(Latitud,Longitud,'Icon',string(pnr_no_sat),'IconScale',1)
         flag_world = 1

             %FOR REAL TIME DISPLAY SATELLITE ON THE WORLD MAP -->%UNCOMMENT
                 pause(20);
                wmremove([h1 h2]);
       %catch
            %display("error occured");
        %end
      %pause(5)
end



 


