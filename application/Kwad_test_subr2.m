function [KwadT, KwadB,  pp2, cent_mat, ang_vec ] = Kwad_test_subr2( pp2, cent_mat, ang_vec, R1, R2, jmp, radi, reso, kk )
%  7.21.18 update for Obj Ori notation
% R1 is topp...
%  7.18.18 subroutine for 3 drone Kwad func
%  called by Kwad3...
% only 2 RRs are involved 3 possible pairs

%load C:/MatlabR12/DahTah/WGdata18/cent_dist_list

ang = ang_vec;
det_flg = 1;
%topp = R1;
while det_flg == 1
    atak_ang = atan2( (cent_mat(2, R1) - cent_mat(2, R2) ) ,  (cent_mat(1, R1) - cent_mat(1, R2) ) ) ;
    ang_diff = ang(R1) - atak_ang ; % attack angle
    ang_diffB = ang(R2) - atak_ang ;
    
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
    
    ang_rev1 = ang(R1) + pi; % ready to backup, rev angle
    ang_rev1 = rem(ang_rev1, 2*pi) ;
    jmpRA = jmp(R1)*(1+rand(1) ) ;
    pp2(1, :, R1) = pp2(1, :, R1) + cos(ang_rev1)*jmpRA * ones(1, reso) ;  % back up first
    pp2(2, :, R1) = pp2(2, :, R1) + sin(ang_rev1)*jmpRA  * ones(1, reso) ;
    cent_mat(:, R1) = [ cent_mat(1, R1)+cos(ang_rev1)*jmpRA  cent_mat(2, R1)+sin(ang_rev1)*jmpRA  ];
    
    ang_rev2 = ang(R2) + pi;
    ang_rev2 = rem(ang_rev2, 2*pi) ;
    jmpRB = jmp(R2)*(1+rand(1) ) ;
    pp2(1, :, R2) = pp2(1, :, R2) + cos(ang_rev2)*jmpRB * ones(1, reso) ;  % back up first
    pp2(2, :, R2) = pp2(2, :, R2) + sin(ang_rev2)*jmpRB  * ones(1, reso) ;
    cent_mat(:, R2) = [ cent_mat(1, R2)+cos(ang_rev2)*jmpRB  cent_mat(2, R2)+sin(ang_rev2)*jmpRB  ];
    
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
    
    [ pp2(:, :, R1), cent_mat(:, R1), ang(R1) ] = Rot_sub_Cent2(pp2(:, :, R1), cent_mat(:, R1), ang(R1), alphT) ;
    [ pp2(:, :, R2), cent_mat(:, R2), ang(R2) ] = Rot_sub_Cent2(pp2(:, :, R2), cent_mat(:, R2), ang(R2), alphB) ;
    
    %close 
    %PrintPlotRR3( reso, pp2, cent_mat, [ 40 40 ], 0, 4 ) % debug 
    
    [ det_flg Q1 Q2 ] = CollisionDetect2( cent_mat, radi,kk ) ;
    
end % while det_flg

ang_vec = ang; 


end

