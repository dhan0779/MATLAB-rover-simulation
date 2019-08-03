function [ TwoXTwo ] = TwoD_rot_mat18( thet )
%6.14.18 as such 
% assume centered on origin 

TwoXTwo =  [ cos(thet)  -sin(thet)  ; sin(thet)  cos(thet) ] ;

end

