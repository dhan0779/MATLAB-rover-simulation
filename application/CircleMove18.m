function [ pp ] = CircleMove18( cent, reso, radi )
%JDD 5.1.18 draw circle
%   where is the nose? 

 for jj = 1:reso 
     rr=jj*2*pi/reso;  
     pp(jj, 1) = ( cent(1) +radi*cos(rr) ) ;
     pp(jj, 2) = ( cent(2) + radi*sin(rr) ) ; 
     pp(jj, 3) = rr;  
 end
 pp
 
 plot( pp(:,1), pp(:, 2) )

axis([0 10.1 0 10.7]);
axis equal


rot2_mat = [ -sin(thet) cos(thet) ; cos(thet) sin(thet) ] 

end % of func

