function [ pp2 ] = Update_pp2( pp2, cent_mat, ang_vec, NN )
%7.23.18 Rox use tail chase ang_vec to alter pp2 by rot only 
% convert pp to pp2
% pp already centers on origin 

pp2_orig = pp2;
load C:/MatlabR12/DahTah/WGdata18/save_pp
pp2 = pp;

for qq = 1:NN
    if pp2_orig(1, 1, qq) ~= 0 &&  pp2_orig(1, 1, qq) ~= 40
        % and not == 40
        
        rot_mat(:, :, qq)  = TwoD_rot_mat18( ang_vec(qq) ) ;
        
        pp2(:, :, qq) = rot_mat(:, :, qq) * pp2(:,  :, qq) ;
        
        pp2(:, :, qq) = pp2(:, :, qq) + cent_mat(:, qq) ;
    end
    
    if pp2_orig(1, 1, qq) == 0
        pp2(:, :, qq) = zeros(2, 17);
    end
    
    if pp2_orig(1, 1, qq) == 40
        pp2(:, :, qq) = ones(2, 17)*40;
    end
    
end

