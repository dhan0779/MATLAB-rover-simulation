function [ pp, cent, ang ] = Rot_sub_Cent(pp, cent, ang, reso, alph, jmp ) 
%jump back, subtract cent, rot then add cent back
% ang is the ang 0 to 2*pi that pp is pointing. 
% could be calculated from cent and rear of pp
% embryonic = original = embry

% tael_ndx = (reso -1)/2 + 1; 
% tael = pp(:, tael_ndx) ; 

ang_rev = ang + pi; 
ang_rev = rem(ang_rev, 2*pi) ; 

pp(1, :) = pp(1, :) + cos(ang_rev)*jmp*3 * ones(1, reso) ;  % back up first 3x 
pp(2, :) = pp(2, :) + sin(ang_rev)*jmp*3 * ones(1, reso) ; 
cent = [ cent(1)+cos(ang_rev)*jmp*3  cent(2)+sin(ang_rev)*jmp*3  ]; 
%pp(2, end+1) = pp(2, end-1);
%cent(:, end+1) = cent(:, end-1) ; % back up cent

pp(1, :) = pp(1, :) - cent(1); %take cent to origin
pp(2, :) = pp(2, :) - cent(2); 

rotamat = TwoD_rot_mat18( alph ) ; 
pp = rotamat*pp; % rotate alpha 1;
ang = ang + alph; 
ang = rem(ang, 2*pi) ;

pp(1, :) = pp(1, :) + cent(1); % return to embry
pp(2, :) = pp(2, :) + cent(2); 


end

