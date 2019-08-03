function [ inact, row_kill, pp2, cent_mat, jmp ] = Inactivate_test4(bool1,bool2,bool3,bool4,radi,pp,ang_vec, pp2, cent_mat, kdist, reso, jmp, kk, repeet, R1, R2, die_flg ,energy)
% at end of code, stop creation of dup all-40 RR 8.5.18
% 8.2.18 incorp own collision at edge death
% 7.31.18 stop two kills of one RR... rev 3
% save BlkHole40 for last 2 roving 7.29
% 7.21.18 update for NN = 4
% check 3 rovers for inactivation
%  kdist is kill distance, likely 0.6

kill_now = 0 ;

ded40 = find(pp2(1, 1, :) == 40); 
ded40_sze = size(ded40, 1); 
ded0 =  find(pp2(1, 1, :) == 0); 
ded0_sze = size(ded0, 1) ; 
dedTot = ded40_sze + ded0_sze; 

if die_flg == 0  && dedTot < 3
    
    Vsw_LLF = ones(4)*99; % V switch kill forward
    Vsw_LLR = ones(4)*99;
    inact = 0;
    row_kill = 0;
    
    T40 = find( pp2(1, 1, :) ==40) ; % knock out dead RRs
    if isempty(T40)
        T40 = 0;
    end
    T0 = find( pp2(1, 1, :) ==0) ;
    if isempty(T0)
        T0 = 0;
    end
    
    for ii = 1:3
        for jj = ii+1:4
            if  T40 == jj  || T0 == jj || T40 == ii  || T0 == ii
                dist8 = 99;
                distA = 99;
            else
                dist8 = sqrt( sumsqr(pp2(:, 1, ii) - pp2( :, (reso-1)/2+1, jj) ) ) ;
                distA = sqrt( sumsqr(pp2(:, reso, ii) - pp2( :, (reso-1)/2+1, jj) ) ); % skip over 9, base 2 10
                Vsw_LLF(ii, jj) = min( [ dist8; distA ] ) ;
            end
        end
    end
    
    for jj = 4:-1:2
        for ii = jj-1:-1:1
            if  T40 == jj  || T0 == jj || T40 == ii  || T0 == ii
                dist8R = 99;
                distAR = 99;
            else
                dist8R = sqrt( sumsqr(pp2(:, 1, jj) - pp2( :, (reso-1)/2+1, ii) ) ); % now jj kills ii
                distAR = sqrt( sumsqr(pp2(:, reso, jj) - pp2( :, (reso-1)/2+1, ii) ) ) ;
                Vsw_LLR(jj, ii) = min( [ dist8R; distAR ] ) ;
                %Vsw_LLR = Vsw_LLR' ; % to place the killer on the left col = rows
            end
        end
    end
    
    [VswF, ndxF] = min(Vsw_LLF) ;
    [VrowF, colF] = min(VswF) ;
    if VrowF < kdist
        inact= colF;
        %pp2(:, :, colF) = pp2(:, :, colF) + 40;
        %cent_mat(:, colF) = cent_mat(:, colF) + 40;
        %jmp(colF) = 0;
        row_kill = ndxF(colF);
        fprintf( ' #%d  UNIT INACTIVATED by killer  %d  at kk= %d  \n', inact, row_kill, kk)
        kill_now = 1;
        
        load  H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable
        scor_mat(s2, : ) = [ row_kill inact kk  ] ;
        s2 = s2 + 1;
        save H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable scor_mat s2 done_flg
    end
    
    [VswR, ndxR] = min(Vsw_LLR) ; % the reverse test
    [VrowR, colR] = min(VswR) ;
    if VrowR < kdist && kill_now == 0
        inact = colR;
        %pp2(:, :, ndxR(colR)) = pp2(:, :, ndxR(colR) ) + 40;
        %cent_mat(:, ndxR(colR)) = cent_mat(:, ndxR(colR) ) + 40;
        %jmp(colR) = 0;
        row_kill = ndxR(colR);
        fprintf( ' #%d  UNIT INACTIVATED by killer  %d at kk= %d  \n', inact, row_kill, kk)
        
        load  H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable
        scor_mat(s2, : ) = [ row_kill inact kk ] ;
        s2 = s2 + 1;
        save H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable scor_mat s2 done_flg
    end
    
    if row_kill > 0 && min(min(min(pp2))) == 0 && max(max(max(pp2))) == 40
        disp( ' only one RR left')
        
        load  H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable
        %scor_mat(s2, : ) = [ row_kill inact kk ] ;
        s2 = s2 + 1;
        done_flg = 1;
        save H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable scor_mat s2 done_flg
        pp2(:, :, inact) = [  ones(1, reso)*40 ;  ones(1, reso)*20 ] ;
        cent_mat(:, inact) = [ 40 ; 20 ] ;
        hold off
        %figure(1)
        PrintPlotRR3(bool1,bool2,bool3,bool4,radi,pp,ang_vec, reso, pp2, cent_mat, [ 40 40 ], kk+1, 4 , energy)
        
        if repeet ~= 3  %repeet ~= 2 || 
            FF(256) = struct('cdata',[],'colormap',[]);
            drawnow
            FF(kk) = getframe;
            save H:/Documents/MATLAB/DahTah/WGdata18/FFnow  FF
        end
        
        if repeet ~= 3
            pause(2) % the end of a game... 
        end
        smsz = size(scor_mat, 1);
        fprintf(' smsz = %d \n', smsz)
        load H:/Documents/MATLAB/DahTah/WGdata18/FFnow % bring in FF for argout
        if smsz > 3
            keyboard
        end
        return
        %keyboard
    end
    
end % of if die_flg == 0 

if dedTot == 3
    disp('dedTot circumstance...Inactivate') 
    inact = 99; 
    row_kill = 88; 
    return
end

if die_flg > 0 % code from own goal  die_flg is dead 
    if die_flg == R1
        row_kill = R2 ;
        inact = R1;
    elseif die_flg == R2
        row_kill = R1 ;
        inact = R2;
    else
        disp('error with die_flg at end of Inactive...') 
        keyboard
    end
     fprintf( ' #%d  UNIT INACTIVATED by killer  %d at kk= %d Off Edge \n', inact, row_kill, kk)
end

if row_kill ~= 0
    T44 = find( pp2(1, 1, :) ==40) ;
    T0 =  find( pp2(1, 1, :) ==0) ;
    if isempty(T0) == 0 % there is an all 0 RR already
        % go ahead and fill in inact with 40s
        pp2(:, :, inact) = ones( 2, reso)*40 ; % bring in feeld at some point
        cent_mat(:, inact) = ones(2, 1)*40;
        jmp(inact) = 0;
        Only2 = 1;
        save H:/Documents/MATLAB/DahTah/WGdata18/BlkHole40 Only2
    elseif  min(jmp) > 0
        pp2(:, :, inact) = zeros( 2, reso) ;
        cent_mat(:, inact) = zeros(2, 1);
        jmp(inact) = 0;
    else
        disp('problem in Inactive_test4 bottom of code')
        keyboard
    end
end


end

