function [ RR_scor, scor_arry ] = Tourney18( TT )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

RR_scor = zeros(1, 4) ;
for zz = 1:TT
    tic
    %[ feeld, kk, scor_mat, FF ] = exerNNrovers8( 2,  0, 2.25, 17, 256);
    [feeld, kk, scor_mat, FF ] = exerNNrovers8T( 0, 0, 2.25, 17, 384 );
    scor_arry{:, :, zz} = scor_mat;
    sm_sze = size(scor_mat, 1) ;
    if sm_sze > 3
        disp('too many kills')
        scor_mat
        save H:/Documents/MATLAB/DahTah/WGdata18/Tourney  RR_scor scor_arry scor_mat
        keyboard
    end
    for tt = 1:sm_sze
        RR_scor(scor_mat(tt,1) ) = RR_scor(scor_mat(tt, 1) ) + 2*2^(tt-1);
        RR_scor(scor_mat(tt,2) ) = RR_scor(scor_mat(tt, 2) ) -  1*2^(3-tt);
    end
    
    fprintf('  %d = the game in the tourney  %6.2f  \n', zz, toc)
end
save H:/Documents/MATLAB/DahTah/WGdata18/Tourney  RR_scor scor_arry scor_mat
for tt = 1:TT
    scor_arry{tt} ;
end
disp(' RR4 efficiency')
RR_scor(4)/sum(RR_scor)

end

