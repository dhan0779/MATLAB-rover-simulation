function [ KwadA, KwadB, KwadC, ppA, ppB, ppC  ] = Quad_test_collision3( ppA, ppB, ppC, jmp, reso, radi, feeld )
% rev 3, 7.18.18  update for 3 drones 
% rev 2--- 7.16.18 now for Kwad of lower rover too
% assume cent dist < 2*radi 
%  lower rover has the attack angle 
% jump back distance is a parameter for mutating

rng('shuffle') 

load C:/MatlabR12/DahTah/WGdata18/cent_dist_list
% dist_list cent_dist_sq12 cent_dist_sq13 cent_dist_sq23 cnt1 cnt2 cnt3 ang1 ang2 ang3 

KwadA = 0; 
KwadB = 0;
KwadC = 0;

[YY, ndx3] = min( [cent_dist_sq12 cent_dist_sq13 cent_dist_sq23 ] ) ;

switch ndx3
    case 1 % 1, 2
        ppA2 = ppA;
        ppB2 = ppB;
        cent11 = cent1;
        cent22 = cent2;
        ang11 = ang1;
        ang22 = ang2;
    case 2 % 1, 3
        ppA2 = ppA;
        ppB2 = ppC;
        cent11 = cent1;
        cent22 = cent3;
        ang11 = ang1;
        ang22 = ang3;
    case 3
        ppA2 = ppB;
        ppB2 = ppC;
        cent11 = cent2;
        cent22 = cent3;
        ang11 = ang2;
        ang22 = ang3;
end

[ KwadA2, KwadB2, ppA2, ppB2, cent11, cent22, ang11, ang22 ] = Kwad_test_subr( ppA2, ppB2, cent11, cent22, ang11, ang22, jmp, radi, reso, feeld ) ;
 %[ ppA, ppB, cent1, cent2, ang1, ang2 ] 
 %load C:/MatlabR12/DahTah/WGdata18/cent_dist_list

switch ndx3
    case 1 % 1, 2
        ppA = ppA2;
        ppB = ppB2;
        cent1 = cent11;
        cent2 = cent22;
        ang1 = ang11;
        ang2 = ang22;
        KwadA = KwadA2;
        KwadB = KwadB2;
    case 2 % 1, 3
        ppA = ppA2;
        ppC = ppB2;
        cent1 = cent11;
        cent3 = cent22;
        ang1 = ang11;
        ang3 = ang22;
        KwadA = KwadA2;
        KwadC = KwadB2;
    case 3
        ppB = ppA2;
        ppC = ppB2;
        cent2 = cent11;
        cent3 = cent22;
        ang2 = ang11;
        ang3 = ang22;
        KwadB = KwadA2;
        KwadC = KwadB2;
end
save C:/MatlabR12/DahTah/WGdata18/cent_dist_list cent_dist_sq12 cent_dist_sq13 cent_dist_sq23 cent1 cent2 cent3 ang1 ang2 ang3

end % of func

