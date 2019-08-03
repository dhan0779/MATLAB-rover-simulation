function RR_scor = Test_Score(  ) 

load C:/MatlabR12/DahTah/WGdata18/Tourney

RR_scor = [ 0 0 0 0];

for zz = 1:4
   scor_mat = scor_arry{:, :, zz} ;
   sm_sze = size(scor_mat, 1) ;
   for tt = 1:sm_sze
      RR_scor(scor_mat(tt,1) ) = RR_scor(scor_mat(tt, 1) ) + 2*2^(tt-1);
      RR_scor(scor_mat(tt,2) ) = RR_scor(scor_mat(tt, 2) ) -  1*2^(3-tt);
   end
end