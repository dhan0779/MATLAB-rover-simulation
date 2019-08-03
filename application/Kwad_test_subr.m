function [KwadT, KwadB,  ppA, ppB, cent1x, cent2x, ang1, ang2 ] = Kwad_test_subr( ppA, ppB, cent1x, cent2x, ang1, ang2, jmp, radi, reso, feeld )
%  7.18.18 subroutine for 3 drone Kwad func  
%  called by Kwad3... 
% only 2 RRs are involved 3 possible pairs 

%load C:/MatlabR12/DahTah/WGdata18/cent_dist_list

if cent1x(2) > cent2x(2) % which rover is up? 
    topp = 1;
    atak_ang = atan2( (cent1x(2)-cent2x(2)) , cent1x(1)-cent2x(1) ) ; 
    ang_diff = ang1 - atak_ang ; % attack angle 
    ang_diffB = ang2 - atak_ang ;
else
    topp = 2 ;
    atak_ang = atan2( (cent2x(2)-cent1x(2)) , cent2x(1)-cent1x(1) ) ; 
    ang_diff = ang2 - atak_ang ;
    ang_diffB = ang1 - atak_ang ;
end

if ang_diff < 0 
    ang_diff = 2*pi + ang_diff; 
end

if ang_diff < pi && ang_diff > pi/2
    KwadT = 1;
elseif     ang_diff < pi/2 && ang_diff > 0
    KwadT = 2;
elseif    ang_diff <2*pi && ang_diff > 3*pi/2
    KwadT= 3;
else
    KwadT = 4 ;
end

% ---------------   -------------------

if ang_diffB < 0 
    ang_diffB = 2*pi + ang_diffB; 
end

if ang_diffB > pi && ang_diffB < 3*pi/2
    KwadB = 2;
elseif     ang_diffB < pi/2 && ang_diffB > 0
    KwadB = 4;
elseif    ang_diffB <2*pi && ang_diffB > 3*pi/2
    KwadB= 1;
else %pi/2  to pi
    KwadB = 3 ;
end

ang_rev1 = ang1 + pi; % ready to backup, rev angle  
ang_rev1 = rem(ang_rev1, 2*pi) ; 
jmpRA = jmp*(1+rand(1) ) ;
ppA(1, :) = ppA(1, :) + cos(ang_rev1)*jmpRA * ones(1, reso) ;  % back up first 
ppA(2, :) = ppA(2, :) + sin(ang_rev1)*jmpRA  * ones(1, reso) ; 
cent1x = [ cent1x(1)+cos(ang_rev1)*jmpRA  cent1x(2)+sin(ang_rev1)*jmpRA  ]; 

ang_rev2 = ang2 + pi; 
ang_rev2 = rem(ang_rev2, 2*pi) ;
jmpRB = jmp*(1+rand(1) ) ;
ppB(1, :) = ppB(1, :) + cos(ang_rev2)*jmpRB * ones(1, reso) ;  % back up first
ppB(2, :) = ppB(2, :) + sin(ang_rev2)*jmpRB  * ones(1, reso) ;
cent2x = [ cent2x(1)+cos(ang_rev2)*jmpRB  cent2x(2)+sin(ang_rev2)*jmpRB  ];

alphCCW = pi/4 + (pi/2)*rand(1) ;
alphCW = -pi/4  - (pi/2)*rand(1);
% CCW is + !

coll_inter_mat = [  { [-1 -1 ]   [1 1 ]  [-1 -1 ]   [-1 -1 ]  } ; { [-1 -1 ]   [-1 -1 ]  [-1 +1 ]   [1 1 ]  } ; ...
    { [ -1 -1 ]   [+1 -1 ]  [1 1 ]   [1 1 ]  } ; { [1 1 ]   [-1 -1 ]  [1 1 ]   [1 1 ]  }  ]  ;

alph_sgn = coll_inter_mat{KwadB, KwadT} ;
if alph_sgn(1) == 1 
    alphB = alphCCW ;
else
    alphB = alphCW;
end

if alph_sgn(2) == 1
    alphT =  alphCCW ;
else
    alphT = alphCW;
end

[ ppA, cent1x, ang1 ] = Rot_sub_Cent2(ppA, cent1x, ang1, alphT) ;
[ ppB, cent2x, ang2 ] = Rot_sub_Cent2(ppB, cent2x, ang2, alphB) ;
    
radi_sq = (2*radi)^2 ; % test for continued overlap below 
cent_dist_sq = sumsqr(cent1x - cent2x);
while cent_dist_sq < radi_sq
    mid_est = feeld/2 ; % max( [ppA ppB]'/2 ) ; 
    cent_dist_midA = sqrt( sumsqr( cent1x - mid_est ) );
    cent_dist_midB = sqrt( sumsqr( cent2x - mid_est ) );
    [ YY, ndx] = min( [ cent_dist_midA cent_dist_midB ] );  
    switch ndx
        case 1
            ang2mid = atan2(cent1x(2) - mid_est(2), cent1x(1) - mid_est(1) ) + pi; % dir it seems 
            ppA(1, :) = ppA(1, :) + cos(ang2mid)*1 * ones(1, reso) ;  % go to the middle
            ppA(2, :) = ppA(2, :) + sin(ang2mid)*1  * ones(1, reso) ;
            cent1x = [ cent1x(1)+cos(ang2mid)*1  cent1x(2)+sin(ang2mid)*1  ];  % jmp out in while
            
        case 2
            ang2mid = atan2(cent2x(2) - mid_est(2), cent2x(1) - mid_est(1) ) + pi ;
            ppB(1, :) = ppB(1, :) + cos(ang2mid)*1 * ones(1, reso) ;  % go to the middle
            ppB(2, :) = ppB(2, :) + sin(ang2mid)*1  * ones(1, reso) ;
            cent2x = [ cent2x(1)+cos(ang2mid)*1  cent2x(2)+sin(ang2mid)*1  ]; 
    end
    cent_dist_sq = sumsqr(cent1x - cent2x);
end
%save C:/MatlabR12/DahTah/WGdata18/cent_dist_list cent_dist_sq12 cent_dist_sq13 cent_dist_sq23 cent1 cent2 cent3 ang1 ang2 ang3

end

