function [pp, pp2, cent_mat, ang_vec, feeld, jmp ] = CreateMdeLs6(bool1,bool2,bool3,bool4, reso, radi, NN,energy )
% 7.26.18  RR4 with fixed init cond
% 7.20.18 now time for 3-dim pp of 4 RRs
% 7.17.18 add 3 then the 4th, ppU

% cent(4, :) = [ (1/8)*feeld(1)  (7/8)*feeld(2) ]
% ang(4) = 1*pi/4 + rands(1)*pi/5
% jmp = 0.7

% 7.4.18 random ang and cent from oppo quads
% 7.1.18 now create N rovers.
%6.14.18 2D RR Say field is 15 x 12?
%   create pp 2 rows x reso columns
% reso is 4*N + 1  mod 4
% row 1 X  row 2 Y
%   [ pp, cent, ang ]  = CreateMdeL( 17, 2, [4 3], pi/5, [15  12] )

switch NN
    case 1
        feeld = [16  16] ;
    case 2
        feeld = [24  24] ; % divide by 8...
    case 3
        feeld = [32  32] ;
    case 4
        feeld = [40  40] ;
end

for qq = 1:NN % NN fixed at 4
    for jj = 1:reso % odd number
        rr = 2*pi * (1+2*(jj-1) ) / (2*reso) ; % for symmetry
        
        rrck(jj) = rr; % debug
        
        pp( 1, jj, qq) = radi*cos(rr)  ; % around orig
        pp( 2, jj, qq) = radi*sin(rr)   ;
    end
    
    switch qq
        case 1
            cent = [ (3/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ; (1/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ];
            cent_mat(:,qq) = cent ;
        case 2
            cent = [ (3/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ; (3/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ] ;
            cent_mat(:, qq) = cent ;
        case 3
            cent = [ (1/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ; (3/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ] ;
            cent_mat(:, qq) = cent ;
        case 4
            cent = [ (1/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ; (1/4)*feeld(1)+rands(1, 1)*feeld(1)*(2/16) ] ;
              cent = [ 20; 4] ;
            cent_mat(:, qq) = cent ;       
    end
    
    switch qq % angle of attack 
        case 1
            ang_vec(1, qq) = 3*pi/4 + rands(1, 1)*pi/3.9 ; % swing out to edge and middle
        case 2
            ang_vec(1, qq) = 5*pi/4 + rands(1, 1)*pi/3.9 ;
        case 3
            ang_vec(1, qq) = 7*pi/4 + rands(1, 1)*pi/3.9 ;
        case 4
            %ang_vec(1, qq) = 1*pi/4 + rands(1, 1)*pi/3.9 ;
            ang_vec(1, qq) = 1*pi/4.1; 
    end
end

save H:/Documents/MATLAB/DahTah/WGdata18/save_pp pp reso 

pp_orig = pp; % preserve before rot

for qq = 1:NN
    rot_mat(:, :, qq)  = TwoD_rot_mat18( ang_vec(qq) ) ;
    pp2(:, :, qq) = rot_mat(:, :, qq) * pp(:,  :, qq) ;
    
    pp2(:, :, qq) = pp2(:, :, qq) + repmat( cent_mat(:, qq), 1, reso ) ; % yes, group add works
end

for jj =1:NN
    jmp(jj) = 0.6 ;
end

save H:/Documents/MATLAB/DahTah/WGdata18/Create_sve pp2  cent_mat  ang_vec  feeld jmp

close all
PrintPlotRR3(bool1,bool2,bool3,bool4,radi,pp,ang_vec, reso, pp2, cent_mat, feeld, 0, NN ,energy)

end

