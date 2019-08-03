function [ det_flg R1 R2 ] = CollisionDetect2( cent_mat, radi, kk )
% 7.24.18  inhibit RR with cent values of 0 or 40... 
%7.20.18 obj ori rev for detecting, called in exerNN5
%   use of min with index 

det_flg = 0;
R1 = 0;
R2 = 0; 

cent_dist = ones(4)*99 ;

diam = 2*radi; 

for ii = 1:3
    for jj = ii+1:4
        cond1 = cent_mat(1, ii) == 0  || cent_mat(1, ii) == 40;
        cond2 = cent_mat(2, jj) == 0  || cent_mat(2, jj) == 40;
        
        if cond1 || cond2
            cent_dist(ii, jj) = 22; % force it to be rejected 
        else
            cent_dist(ii, jj) = sqrt( sumsqr(cent_mat(:,ii)' - cent_mat(:, jj)' ) );
        end
    end
end

[Y2, nde] = min(cent_dist) ; 

if min(Y2) < diam
    LT45 = find(Y2  <diam) ;
    [ YY ndd] = min(Y2) ;
    det_flg = size(LT45, 2) ;   
    
    h1 = cent_mat(2,ndd) ; % height
    h2 = cent_mat(2, nde(ndd)) ;
    
    if h2 < h1
        R1 = ndd;
        R2 = nde(ndd);
    else
        R2 = ndd;
        R1 = nde(ndd);
    end
end

if kk > 100 && det_flg > 0
    det_flg;
end

end

