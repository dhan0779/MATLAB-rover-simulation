function [ YesClose, ang_vec, jmp  ] = Tail_Chase18D(pp2, ang_vec, jmp, reso, tailT, NN )
% 7.24.18 rev D-- prevent dead RRs from being selected for tail chase 
% mde is RR both=2 direc 
% rev C align with Obj Ori notation 7.21.18
% first inspect Left sensor matrix, then Right sensor matrix
% forming mde( sensor  1or2<tailT direcCWorCCW )
% CW is -1 direc CCW is +1 direc
% rev B improve threshold logic
% 3 drone tail chase 7.19.18
%   TailT = tail thet about 10 if thet/2 then go straight

%load C:/MatlabR12/DahTah/WGdata18/Tail_Chase
% ppA ppB ppC cent1 cent2 cent3 ang1 ang2 ang3 jmp1 jmp2 jmp3

YesClose = 0;

Left2tail = ones(4)*99;
Rght2tail = ones(4)*99;

Lft_tRn_ang = 0.4 ;
Rht_tRn_ang = -0.4 ;

jmp = ones(1, 4)*0.6 ;

mde = [ 0 0 0 ];
% rover#  1or2<tailT  direc

T40 = find( pp2(1, 1, :) ==40) ; % knock out dead RRs 
if isempty(T40) 
    T40 = 0;
end
T0 = find( pp2(1, 1, :) ==0) ;
if isempty(T0) 
    T0 = 0;
end

for ii = 1:4
    for jj = 1:4
        if ii == jj  || T40(1) == jj  || T0 == jj || T40(1) == ii  || T0 == ii 
            Left2tail(ii, jj) = 99 ;
        else
            Left2tail(ii, jj) =  sqrt( sumsqr( pp2( :, (reso-1)/4, ii ) - pp2(:, (reso-1)/2+1, jj ) ) )  ;
            Rght2tail(ii, jj) = sqrt( sumsqr( pp2( :, end-(reso-1)/4+1, ii ) - pp2(:, (reso-1)/2+1, jj ) ) )  ;
        end
    end
end

[Lval Ldx] = min(Left2tail) ;
L10 = find(Lval < tailT) ;
preyL = Ldx(1) ;
predL = Ldx(preyL) ;

[Rval Rdx] = min(Rght2tail) ;
R10 = find(Rval < tailT) ;
preyR = Rdx(1) ;
predR = Rdx(preyR) ;

if isempty(L10)==0  ||  isempty(R10)==0

if isempty(L10) && isempty(R10)
    return
end

YesClose = 1; 

 find2rc = [ 1 1; 2 1; 3 1; 4 1;  1 2; 2 2; 3 2; 4 2;  1 3; 2 3; 3 3; 4 3;  1 4; 2 4; 3 4; 4 4 ] ;
 % table lookup! 

DotL = find(Left2tail <tailT) ; % DotL comes as a column
DotR = find(Rght2tail <tailT) ;


cnt = 1;
% test Left sensor matrix
if isempty(DotL) == 0
    LL_sze = size(DotL, 1) ;
    for LL = 1:LL_sze
        colL(LL) = find2rc( DotL(LL), 2)  ;  % (ceil(DotL(LL)/NN) ;
        rowL(LL) = find2rc( DotL(LL), 1)  ;   %rem(DotL(LL), (NN+1) ) ; % col is the tail        
        chk_DD = find(DotR  ==DotL(LL) ) ;
        if isempty(chk_DD) == 0 % Right side LT tailT +> both in Dot are small dist
            diffL = Left2tail( rowL(LL), colL(LL) ) - Rght2tail( rowL(LL), colL(LL) ) ;
            % smaller distance, closer... neg diff => go CW
            if diffL > 0 % implies R lower...
                mde(cnt, :) = [ rowL(LL)  2  -1 ] ; % pos => go right is closer
            else % diffL > 0
                mde(cnt, :) = [ rowL(LL)  2  +1 ] ; % neg => go left 
            end
            cnt = cnt+1;
        else % only Left below tailT
            mde(cnt, :) = [ rowL(LL)  1  +1 ] ;
            cnt = cnt+1;
        end
        %LL = LL+1;
    end
end

cntR = 1; % test Right matrix for leftover detections 
DotS = [ ];
if  isempty(DotR) == 0
    RR_sze = size(DotR, 1) ;  % a col
    cnt0 = 0;
    for zz = 1:RR_sze
        fnd0 = find( DotL ==DotR(zz) ); % already accounted?
        if isempty(fnd0)
            cnt0 = cnt0+1;
            DotS(cnt0, 1) = DotR(zz) ; % shorter list
        end
    end
    
    if isempty(DotS) == 0
        SS_sze = size(DotS, 1) ;
        for SS = 1:SS_sze
            colL(cntR) = find2rc( DotS(SS), 2)  ;
            rowL(cntR) = find2rc( DotS(SS), 1)  ;
            mde(cnt, :) = [ rowL(cntR)  1  -1 ] ;
            cnt = cnt  + 1; 
        end
    end
end

mde_sze = size(mde, 1);
for mm = 1:mde_sze
    if mde(mm, 2) >= 1
        if mde(mm, 3)  == 1
            ang_vec(mde(mm) ) = ang_vec( mde(mm) ) + Lft_tRn_ang ;
            jmp( mde(mm) ) = 0.85 ;
        else
            ang_vec(mde(mm) ) = ang_vec( mde(mm) ) + Rht_tRn_ang ;
            jmp( mde(mm) ) = 0.85 ;
        end
    else % both L and R < tailT
        if mde(mm, 2) == 2
            if mde(mm, 3) == 1
                ang_vec(mde(mm) ) = ang_vec( mde(mm) ) + Lft_tRn_ang/2 ;
                jmp( mde(mm) ) = 0.95 ;
            else % direc is -1
                ang_vec(mde(mm) ) = ang_vec( mde(mm) ) + Rht_tRn_ang/2 ;
                jmp( mde(mm) ) = 0.95 ;
            end
        end %  if mde(mm, 2) == 2
    end
end



end




