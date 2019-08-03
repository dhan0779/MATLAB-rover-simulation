function [ insid ] = InsideCircle( xx, yy, radi, cntr) 
% InsideCircle 4.11.18 
% yes inside == 1

insid = 0; 
xmin = cntr(1) - radi; 
xmax = cntr(1) + radi; 

ymin = cntr(2) - radi; 
ymax = cntr(2) + radi;

cond1 = xx < xmin || xx > xmax ;
cond2 = yy < ymin || yy > ymax ; 

% better test: 
unk_rad_sqr = ( xx - cntr(1) )^2 + ( yy - cntr(2) )^2 ; 
if sqrt(unk_rad_sqr) > radi 
    insid = 1; 
end

%cntr = [6 7] 

