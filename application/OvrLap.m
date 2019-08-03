function [ LapOvr ] = OvrLap( radi, cntr1, cntr2) 
% OvrLap 4.13.18 
% yes overlap LapOvr == 1
% assume both have same radius 

LapOvr = 0;
delx = cntr1(1) - cntr2(1); 
dely = cntr1(2) - cntr2(2); 
hypot_sqr = delx^2 + dely^2; 
hypot = sqrt(hypot_sqr); 
%sqr_ans = sumsqr([cntr1; cntr2]) ;
diffr = 2*radi - hypot;
if diffr > 0
    LapOvr = 1;
end

end % of function





