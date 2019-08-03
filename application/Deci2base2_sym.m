function [pattr] = Deci2base2_sym (sig_now )
%7.13.19 convert num 2 pattern 4 bit

%sig_now = sig
pattr = zeros(1,4)


for ii = 1:4
    
    if sig_now > 2^(4-ii)
        pattr(ii) = 1;
    end
    sig_now = sig_now - 2^(4-ii) ;
    
    disp(pattr)
    
    
end





end % of func

