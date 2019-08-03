function [ Kwad, topp, ppA, ppB, cent1, cent2, ang1, ang2 ] = Quad_test_collision( ppA, ppB, cent1, cent2, ang1, ang2, jmp, reso )
% assume cent dist < 2*radi 
%  lower rover has the attack angle 
% jump back distance is a parameter for mutating

rng('shuffle') 

Kwad = 0; 
if cent1(2) > cent2(2) % which rover is up? 
    topp = 1
    atak_ang = atan2( (cent1(2)-cent2(2)) , cent1(1)-cent2(1) ) ; 
    ang_diff = ang1 - atak_ang ;
else
    topp = 2
    atak_ang = atan2( (cent2(2)-cent1(2)) , cent2(1)-cent1(1) ) ; 
    ang_diff = ang2 - atak_ang ;
end

if ang_diff < 0 
    ang_diff = 2*pi + ang_diff; 
end

if ang_diff < pi && ang_diff > pi/2
    Kwad = 1;
elseif     ang_diff < pi/2 && ang_diff > 0
    Kwad = 2;
elseif    ang_diff <2*pi && ang_diff > 3*pi/2
    Kwad = 3;
else
    Kwad = 4
end

ang_rev1 = ang1 + pi; % ready to backup, rev angle  
ang_rev1 = rem(ang_rev1, 2*pi) ; 
jmpRA = jmp*(1+rand(1) ) ;
ppA(1, :) = ppA(1, :) + cos(ang_rev1)*jmpRA * ones(1, reso) ;  % back up first 
ppA(2, :) = ppA(2, :) + sin(ang_rev1)*jmpRA  * ones(1, reso) ; 
cent1 = [ cent1(1)+cos(ang_rev1)*jmpRA  cent1(2)+sin(ang_rev1)*jmpRA  ]; 

ang_rev2 = ang2 + pi; 
ang_rev2 = rem(ang_rev2, 2*pi) ;
jmpRB = jmp*(1+rand(1) ) ;
ppB(1, :) = ppB(1, :) + cos(ang_rev2)*jmpRB * ones(1, reso) ;  % back up first
ppB(2, :) = ppB(2, :) + sin(ang_rev2)*jmpRB  * ones(1, reso) ;
cent2 = [ cent2(1)+cos(ang_rev2)*jmpRB  cent2(2)+sin(ang_rev2)*jmpRB  ];

alphCCW = pi/4 + (pi/2)*rand(1) ;
alphCW = -pi/4  - (pi/2)*rand(1);

switch Kwad
    case 1
        if topp == 1
            [ ppA, cent1, ang1 ] = Rot_sub_Cent2(ppA, cent1, ang1, alphCW) ;
            [ ppB, cent2, ang2 ] = Rot_sub_Cent2(ppB, cent2, ang2, alphCCW) ;
        else % if top is 2
            [ ppA, cent1, ang1 ] = Rot_sub_Cent2(ppA, cent1, ang1, alphCCW) ;
            [ ppB, cent2, ang2 ] = Rot_sub_Cent2(ppB, cent2, ang2, alphCW) ;            
        end
        
    case 2
        
    case 3
        
    case 4       
        if topp == 1
            [ ppA, cent1, ang1 ] = Rot_sub_Cent2(ppA, cent1, ang1, alphCCW) ;
            [ ppB, cent2, ang2 ] = Rot_sub_Cent2(ppB, cent2, ang2, alphCW) ;
        else
            [ ppA, cent1, ang1 ] = Rot_sub_Cent2(ppA, cent1, ang1, alphCW) ;
            [ ppB, cent2, ang2 ] = Rot_sub_Cent2(ppB, cent2, ang2, alphCCW) ;
        end        
end % of switch

end % of func 

