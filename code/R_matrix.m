% author : Hakkı Egemen Gülpınar
% BeiDou CGCS2000 Coordinates Equation
% params:
    % param1: type : int  | type1 --> Rx , type 2 --> Rz
    % param2: degree : int
          

% function Rmatrix = R_matrix(type, degree)
% 
% if (type == 0)
%     Rmatrix = [1 0 0 ; 0 cos(degree) sin(degree) ; 0 -sin(degree) cos(degree)]; %Rx
% end
% if (type == 1)
%     Rmatrix = [cos(degree) sin(degree) 0 ; -sin(degree) cos(degree) 0 ; 0 0 1]; %Rz
% end

function Rmatrix = R_matrix(type, degree)

if (type == 1)
    Rmatrix = [1 0 0 ; 0 cos(degree) sin(degree) ; 0 -sin(degree) cos(degree)]; %R1
end
if (type == 2)
    Rmatrix = [cos(degree) 0 -sin(degree); 0 1 0 ; sin(degree) 0 cos(degree)]; %R2
 
end
if (type == 3)
    Rmatrix = [cos(degree) sin(degree) 0 ; -sin(degree) cos(degree) 0 ; 0 0 1]; %R3
end