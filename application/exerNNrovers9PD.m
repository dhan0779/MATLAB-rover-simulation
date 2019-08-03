function [ feeld, kk, scor_mat, FF ] = exerNNrovers9(noplot, repeet, NoRnd, radi, reso, kk_max )
% rev 9 time profile rev Aug 5, Happy Birthday Pixie Dixie CATNIP needed 
% rev 8 incorp matlab movie FF feature 8.1.18
% repeet 3 to supress plot
% replay example:  [feeld, kk, scor_mat, FF ] = exerNNrovers8( 1, 3, 2.25, 17, 127 ) ;
% movie  replay: movie(FF,1,  6)
% rev 7 incorp RandRoundUp save and load for replay func(kk)
% RRU has
% [ alph1 alph2 skip_rand   ndx17   RndA RndB    angCCW angCW
% rev 6B4 to have RR4 stay in it's corner for 100 klicks
% 7.28.18 for use with 2007 Matlab
% 7.24.18 scatter after 100 kk
% don't let jmp go below 0.5 see 0.6*( round(jmp) )  near bottom try ceil
% handle object oriented rev for pp2
% rev 4 accommodate 3 drones 7.18.18
% rev 3 call Quad_test_collision after collision
% 7.4.18 look for cent dist < 2*radi
%creeate and move multiple rovers, with display
% July 1, 2018

rng ; % reset rand num gen
psr = 0.10;
close all
BkUpWalFac = 0.5;
inact = 0;
kdist0 = 1.5 ;
%reso = 17;
%radi = 2.25;
tailT = 7;
NN = 4;
skip_tail = 0;
done_flg = 0;
scor_mat(1, : ) = [ 0 0 0  ] ;
s2 = 1;
Only2 = 0;
die_flg = 0;
%noplot = 0; % yes there will be plots... 
RandRoundUp = zeros(1, 8) ;
%RandRoundUp = zeros(kk_max, 8) ;
save H:/Documents/MATLAB/DahTah/WGdata18/RRU  RandRoundUp

FF(kk_max) = struct('cdata',[],'colormap',[]);

save H:/Documents/MATLAB/DahTah/WGdata18/BlkHole40 Only2
% then only when only 2 left does Only2 change to 1...

switch repeet
    case 1
        %load H:/Documents/MATLAB/DahTah/WGdata18/Create_sve
        %load H:/Documents/MATLAB/DahTah/WGdata18/Create_sve74
        load  H:/Documents/MATLAB/DahTah/WGdata18/Create_sve85
    case {2, 3}
        [ pp2, cent_mat, ang_vec, feeld, jmp ] = CreateMdeLs6B( reso, radi, NN ) ;
        %  [ pp2, cent_mat, ang_vec, feeld, jmp ] = CreateMdeLs6B_OG( reso, radi, NN ) ;
end
jmp_orig = jmp ;

BUstp = BkUpWalFac*jmp ;

radi_sq = (2*radi)^2 ;

save H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable scor_mat s2 done_flg

Only2 = 0;

for kk = 1:kk_max
    die_flg =0 ;
    switch NoRnd
        case 0
            load H:/Documents/MATLAB/DahTah/WGdata18/RRU
            alph1_rnd = rand(1)*pi/4 ;
            alph2_rnd = rand(1)*pi/4 ;
            alph1 = pi/4 +alph1_rnd ; %
            alph2 = -pi/4 -alph2_rnd ; %+  ;
            RandRoundUp(kk, 1:2) = [ alph1 alph2 ] ;
            %save H:/Documents/MATLAB/DahTah/WGdata18/alph1_sve  alph1 alph2
            save H:/Documents/MATLAB/DahTah/WGdata18/RRU  RandRoundUp
        case 1
            load H:/Documents/MATLAB/DahTah/WGdata18/alph1_sve
        case { 2, 3 }
            load H:/Documents/MATLAB/DahTah/WGdata18/RRU
            alph1 = RandRoundUp(kk, 1)  ;
            alph2 = RandRoundUp(kk, 2)  ;
    end
    
    load H:/Documents/MATLAB/DahTah/WGdata18/BlkHole40
    if Only2 == 1
        ded40 = find(pp2(1, 1, :) == 40);
        ded40_sze = size(ded40, 1);
        ded0 =  find(pp2(1, 1, :) == 0);
        ded0_sze = size(ded0, 1) ;
        dedTot = ded40_sze + ded0_sze;
        
        if dedTot == 2
            Only2;
        elseif dedTot == 3
            die_flg = 5;
        end
    end
    
    kdist = 3 - kdist0*exp(-kk/100) ; %asymptote from 1.5 to 3 tau 100 kk
    
    if kk == 37 %rem(kk, 8)  == 0 % ||
        kk;
    end
    
    if jmp(4) == 0
        % jmp(4) = 0.6; % a hack
    end
    if pp2(1, 1, 4) > 0 && max(max(max(pp2))) < feeld(1)
        if kk < 15 ; % min(min(min(pp2))) > 0
            jmp(4) = 0.3;
            krem = rem(kk, 10) ;
            if krem < 5
                ang_vec(4) = 3*pi/4;
                [ pp2 ] = Update_pp2B( pp2, cent_mat, ang_vec, NN, reso  ) ;
            else
                ang_vec(4) = 7*pi/4;
                [ pp2 ] = Update_pp2B( pp2, cent_mat, ang_vec, NN, reso  ) ;
            end
        elseif   pp2(1, 1, 4) ~= 0 && pp2(1, 1, 4) ~= 40   %if kk == 96
            jmp(4) = 0.7;
        end
        %jmp(4) = 0.99;
    end
    
    skip_tail = 0 ;
    if kk > 128 % late scramble
        rem_tst = rem(kk, 80) ;
        if rem_tst == 100
            skip_rand = rands(1, 4) ;
            switch NoRnd
                case 0
                    load H:/Documents/MATLAB/DahTah/WGdata18/RRU
                    RandRoundUp(kk, 3) = skip_rand;
                    save H:/Documents/MATLAB/DahTah/WGdata18/RRU RandRoundUp
                case { 2, 3 }
                    load H:/Documents/MATLAB/DahTah/WGdata18/RRU
                    skip_rand = RandRoundUp(kk, 3) ;
            end
            ang_vec = [ 7*pi/4  1*pi/4  3*pi/4  5*pi/4 ] + skip_rand  ;%  ;
            [ pp2 ] = Update_pp2B( pp2, cent_mat, ang_vec, NN ) ;
            skip_tail = 1;
        end
    end
    
    [ pp2, cent_mat, ang_vec ] = MoveOnWG18J(pp2, cent_mat, ang_vec, reso, jmp, feeld, alph1, alph2, NN, BUstp, Only2, NoRnd, kk ) ;
    %steps ahead, looks to see if any of 4 RRs hit a wall,
    % backs up, then rotates
    
    if NoRnd == 3
        load H:/Documents/MATLAB/DahTah/WGdata18/PP_check
        pp2(:, :, 1) = pp_arry(:, :, 1, kk) ;
        pp2(:, :, 2) = pp_arry(:, :, 2, kk)  ;
        pp2(:, :, 3) = pp_arry(:, :, 3, kk)  ;
        pp2(:, :, 4) = pp_arry(:, :, 4, kk)  ;
        cent_mat  = cen_arry(:, :, kk) ;
        ang_vec = ang_arry(kk, :) ;
        jmp = jmp_arry(kk, :) ;
    end
    
    if noplot == 0 % means if noplot == 1 then no plot
        hold off
        figure(1)
        PrintPlotRR3( reso, pp2, cent_mat, feeld, kk, NN )
    end
    
    if noplot == 0
        drawnow
        FF(kk) = getframe;
        save H:/Documents/MATLAB/DahTah/WGdata18/FFnow  FF
    elseif rem(kk, 25) == 0
        fprintf(' kk = %d  and toc = %6.2f  in exerNNrovers9 line 173 \n', kk, toc)
        
        hold off
        figure(1)
        PrintPlotRR3( reso, pp2, cent_mat, feeld, kk, NN )
        kk; 
        
    end
        
    %disp(jmp)
    if NoRnd == 0
        cen_arry(:, :, kk) = cent_mat;
        ang_arry(kk, :) = ang_vec;
        jmp_arry(kk, :) = jmp;
        pp_arry(:, :, 1, kk) = pp2(:, :, 1) ;
        pp_arry(:, :, 2, kk) = pp2(:, :, 2) ;
        pp_arry(:, :, 3, kk) = pp2(:, :, 3) ;
        pp_arry(:, :, 4, kk) = pp2(:, :, 4) ;
        save H:/Documents/MATLAB/DahTah/WGdata18/PP_check   pp_arry cen_arry ang_arry jmp_arry
    end
    if  noplot == 0
        pause(psr)
    end
    
    [ det_flg R1 R2 ] = CollisionDetect2( cent_mat, radi, kk ) ;
    
    if det_flg > 0
        %disp(det_flg)
        [KwadT, KwadB,  pp2, cent_mat, ang_vec, die_flg ] = Kwad_test_subr6( pp2, cent_mat, ang_vec, R1, R2, jmp, radi, reso, kk, NoRnd ) ;
        % Kwad_test_subr2( pp2, cent_mat, ang_vec, R1, R2, jmp, radi, reso )
    end
    
    if kk > 4
        save H:/Documents/MATLAB/DahTah/WGdata18/cent_sve cent_mat  feeld  NN
        [ inact, row_kill, pp2, cent_mat, jmp ] = Inactivate_test4( pp2, cent_mat, kdist, reso, jmp, kk, repeet, R1, R2, die_flg ) ;
        load  H:/Documents/MATLAB/DahTah/WGdata18/ScoreTable
        if done_flg == 1
            return
        end
    end
    
    if inact > 0
        inact ;
        %keyboard
    end
    
    if kk > 140 && kk < 160
        skip_tail = 1;
    end
    
    if kk > 4
        if skip_tail == 0
            ang_vec;
            jmp;
            T44 = find( pp2(1, 1, :) ==40) ; % knock out dead RRs
            if max( size(T44) ) > 1
                disp('max of 40 list GT than 1 !!  route out after plot')
                keyboard
            end
            %PrintPlotRR3( reso, pp2, cent_mat, feeld, 456, NN )
            save H:/Documents/MATLAB/DahTah/WGdata18/cent_sve cent_mat  feeld  NN
            [ YesClose, ang_vec, jmp  ] = Tail_Chase18D2(pp2, ang_vec, jmp, reso, tailT, NN ) ;
            
            ang_vec;
            jmp;
        end
        
        if YesClose == 0
            jmp = 0.6*( round(jmp) ) ; % keep 0 at 0 ; don't let jmp go below 0.5 or above 1.5
        else
            [ pp2 ] = Update_pp2B( pp2, cent_mat, ang_vec, NN ) ;
            % rotate immediately
        end
    end % kk 20
    skip_tail = 0;
    %             figure(2)
    %             PrintPlotRR3( reso, pp2, cent_mat, feeld, 123, NN )
    %             hold off
    
    smsz = size(scor_mat, 1);
    if smsz > 3
        disp('scor matrix has too many rows')
        keyboard
    end
    
    if smsz > 1;
        smx = find(scor_mat(1:end-1, 2) ==scor_mat(end, 2) ); % col 2 is inact...
        if isempty(smx) == 0
            disp('scor matrix has a dup')
            keyboard
        end
    end
    
end

fprintf(' smsz = %d \n', smsz)
end %of func

