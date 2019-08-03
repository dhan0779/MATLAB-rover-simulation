function [ pp ] = rot_on_wall18( pp, cent, ang, condW, condA, alph1, alph2 )
%% 6.29.18 rotation on various wall, orientation combinations 
%  

%alph1 = pi/3 ; 
if condW == 1 && condA == 1
    pp = Rot_sub_Cent(pp, cent, ang, alph1) 
    
end


end

