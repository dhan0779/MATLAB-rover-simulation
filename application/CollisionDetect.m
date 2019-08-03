function [ det_flg R1 R2 ] = CollisionDetect( cent_mat, radi )
%7.20.18 obj ori rev for detecting, called in exerNN5
%   use of min with index 

det_flg = 0;
R1 = 0;
R2 = 0; 

cent_dist = ones(4)*99 ;

diam = 2*radi; 

for ii = 1:3
    for jj = ii+1:4
        cent_dist(ii, jj) = sqrt( sumsqr(cent_mat(:,ii)' - cent_mat(:, jj)' ) );
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

end

