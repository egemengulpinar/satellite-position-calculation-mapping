%Author : H.Egemen Gülpınar
%BEIDOU SATELLITE POSITION CALCULATION FUNCTION
%ONLY MEO AND IGSO SATELLITE POSITION CALCULATION WORKS CORRECTLY
%GEO SATTELITES HAVE PARTIALLY SAME LONGITUDE-LATITUDE-ALTITUDE DEGREES.

function [Longitude, Latitude,Altitude ,name,esec,Satelitesinfo]= computeposition (beidou_datas,k)
new_data = beidou_datas;
Satelitesinfo = cell(1,3);
result = cell(20,4);
Lat = zeros(10,1);
Lon = zeros(10,1);
Alt = zeros(10,1);
beidou_size = size(beidou_datas);
datas_temp = strings();

counter_sat = 1;

for i = 1:beidou_size(2)
    for j=1:1
        
        try
        flag_geo = 1;    
        %%PARAMETERS OF THE SATELITE TO CALCULATE THE ORBIT
        year = new_data(j+1,i);
        month = new_data(j+2,i);
        day = new_data(j+3,i);
        hour = new_data(j+4,i);
        minute = new_data(j+5,i);
        second = new_data(j+6,i);
        t1 = datetime(str2num(year),str2num(month),str2num(day),str2num(hour),...
        str2num(minute),str2num(second),'TimeZone','UTCLeapSeconds');
        BDS_0= datetime(2006,1,1,0,0,0,'TimeZone','UTCLeapSeconds');
        deltaT = t1 - BDS_0; deltaT.Format = 's';
        tNumeric = time2num(deltaT,"seconds");  
        t=tNumeric;%ACTUAL TIME
        esec = t;
        name_=new_data(j,i); %NAME OF SATELITE
        ecc=str2num(new_data(j+12,i)); %ECCENTRICITY OF THE ORBIT
        toe=str2num(new_data(j+15,i)); %TIME OF APPLICATION
        i0=str2num(new_data(j+19,i)); %ORBIT INCLINATION
        C_rs = str2num(new_data(j+8,i));
        Delta_N = str2num(new_data(j+9,i));
        C_uc = str2num(new_data(j+11,i));
        C_us = str2num(new_data(j+13,i))
        C_ic = str2num(new_data(j+16,i));
        Omega0 = str2num(new_data(j+17,i));
        C_is = str2num(new_data(j+18,i));
        A=str2num(new_data(j+14,i)); %SQUARE ROOT OF THE MAJOR SEMI AXIS
        omega=str2num(new_data(j+21,i)); %ARGUMENT OF THE PERIGEE
        M0=str2num(new_data(j+10,i)); %MEAN ANOMALY AT TOA
        C_rc = str2num(new_data(j+20,i));
        IDOT = str2num(new_data(j+23,i));
        Omegadot = str2num(new_data(j+22,i));
        %FIXED PARAMETERS
        G= 398600.4418 * 10^9; %GRAVIATIONAL CONSTANT
        M=5.972*10^24; %EARTH MASS
        
        Mu=3.986005*10^14;
        Omega_dote=7.2921151467*10^(-5);
        
        tk=t - toe ; %TIME BETWEEN ACTUAL TIME AND TOE
        
            while tk > 302400
                if tk>302400
                    tk = tk - 604800;
                end
            end

            if tk <-302400
                tk = tk + 60480;
            end
        
            Mk = M0 + ((sqrt(Mu) / A^3) + Delta_N )* tk;
            Ek=keplerEq(Mk,ecc,1e-10);
            %True Anomaly
            
            Sin_vk=sqrt(1-ecc^2)*sin(Ek);
            Cos_vk=(cos(Ek)-ecc);
            vk=atan2(Sin_vk,Cos_vk);

            
            %ARGUMENT OF LATITUDE --> uk
            %ARGUMENT OF PERIGEE --> omega
            %TRUE ANOMALY--> vk
            %CORRECTIONS --> C_uc | C_us
            uk = omega + vk + C_uc*cos(2*(omega + vk)) + C_us*sin(2*(omega + vk));
            %RADIAL DISTANCE rk
            rk = A^2 *(1-(ecc*cos(Ek))) + C_rc*cos(2*(omega + vk)) + C_rs*sin(2*(omega + vk));
            %COMPUTE INCLINATION ik
            ik = i0 + IDOT*tk + C_ic *cos(2*(omega + vk)) + C_is * sin(2*(omega + vk));
            
            
            %SATELLITE POSITION IN ORBITAL PLANE
            
            xk = rk*cos(uk);
            yk = rk*sin(uk);
            
            %FIX (C03 OR C 3  | etc.) RINEX DATA PRN ISSUE  
            if isempty(cell2mat(textscan(name_,"%d")))
             
             cur_name_char = char(name_(j));
             cur_PRN =  str2num(cur_name_char(2:3));
            else
             cur_PRN = textscan(name_,"%c %d");
             cur_PRN = cell2mat(cur_PRN(2))
            end
            
             
            % GEO CALCULATION / RTKLib GEO SAT. EQUATION(COMMENT LINES) / BEIDOU C1-C2-C3-C4-C5 GEO
            % SATELLITES POSITION CALCULATION (Not corrected results)
            
            if(cur_PRN <= 5) 
               
                flag_geo = 2; % CONTROL GEO SATELLITES
                break
%                 Lambda_k = Omega0 + Omegadot*tk - Omega_dote*toe;
%                 xg=xk * cos(Lambda_k) - yk * cos(ik) * sin(Lambda_k);
%                 yg=xk * sin(Lambda_k) + yk * cos(ik) * cos(Lambda_k);
%                 zg=yk*sin(ik);
%                 
%                 sino=sin(Omega_dote*tk); coso=cos(Omega_dote*tk);
%                 x_l =  xg*coso+yg*sino*cos(5)+zg*sino*sin(5);
%                 y_l = -xg*sino+yg*coso*cos(5)+zg*coso*sin(5);
%                 z_l = -yg*sin(5)+zg*cos(5);
                
            else % Normal calculation
                %compute longitude of the ascending node Delta_k
                Lambda_k = Omega0 + (Omegadot-Omega_dote)*tk - Omega_dote*toe;          

                x_l = xk*cos(Lambda_k) - yk*cos(ik)*sin(Lambda_k);
                y_l = xk * sin(Lambda_k) + yk*cos(ik)*cos(Lambda_k);
                z_l = yk*sin(ik);
             end
         
            sat_xyz = [x_l; y_l; z_l];

            %POSITION OF THE SATELLITE CALCULATED ORBITAL PLANE(2nd satellite calculation method
            %from the website --> gssc.esa.int gps satellite calculation equation) [same results]
            
            X_GK = xk*cos(Lambda_k) - yk*cos(ik)*sin(Lambda_k);
            Y_GK = xk*cos(Lambda_k) + yk*cos(ik)*sin(Lambda_k);
            Z_GK = yk*sin(ik);
        
            matrix_xyz_GK = [X_GK;Y_GK;Z_GK];
            matrix_rk = [rk;0;0];
            matrix_final_result = [0;0;0];       
            R3 = R_matrix(3, -Lambda_k);
            R1 = R_matrix(1, -ik);
            R3_2 = R_matrix(3, -uk);
            matrix_mul = mtimes(R3,R1);
            matrix_mul2 = mtimes(matrix_mul,R3_2);
            matrix_final_result = mtimes(matrix_mul2,matrix_rk);
            result = ecef2lla(sat_xyz');
            disp(strcat("Lat: ",string(result(1)),"  Lon: ",string(result(2)),"  Alt: ",string(result(3))));
         
        catch
            fprintf('loop number %d failed\n')
        end
        
        Lat = result(1);
        Lon = result(2);
        Alt = result(3);
        end 
        if flag_geo ~= 2  %  CONTROL ONLY MEO & IGSO SATELLITES. GEO SATELLITES NOT INCLUDED
            
            disp(i);
            Latitude(counter_sat,1)=Lat;
            Longitude(counter_sat,1)=Lon;
            Altitude(counter_sat,1) = Alt;
            name(counter_sat,1) = name_

            %USE THE FUNCTION TO CALCULATE THE POSITION OF EACH SATELITE
            name(counter_sat,1);

            Satelitesinfo{counter_sat,2} =Latitude(counter_sat,1);  %PUTS THE LATITUDE IN THE TABLE
            Satelitesinfo{counter_sat,3}= Longitude(counter_sat,1); %PUTS THE LONGITUDE IN THE TABLE
            Satelitesinfo{counter_sat,1}= name(counter_sat,1);      %PUTS THE NAME IN THE TABLE
            Satelitesinfo{counter_sat,4} = Altitude(counter_sat,1); %PUTS THE ALTITUDE IN THE TABLE

            counter_sat = counter_sat + 1;
        end
   
end

end