function [ pp ] = CircleDraw18( cent, reso, radi )
%JDD 5.9.18 draw circle
%   where is the nose? 
% points in columns, not rows...

% points are columns
close all
pause(1)
for jj = 1:reso
    rr=jj*2*pi/reso;
    pp(   1, jj) = ( cent(1) + radi*cos(rr) ) ; % xx
    pp(   2, jj) = ( cent(2) + radi*sin(rr) ) ;
    % pp( 3, jj) = 0;
    % pp( 4, jj) = 1;
end
figure(1)
plot( pp(1, 1:22), pp(2, 1:22), 'r' )
hold on
plot( pp(1, 23:40), pp(2, 23:40), 'g*' )
axis equal
plot( pp(1, 41:reso), pp(2, 41:reso), 'r' )
axis( [0  11    0  10] );
hold off

thet = 0.6;

centr = [ 0 0 ]
for jj = 1:reso
    rr=jj*2*pi/reso;
    ppr( 1, jj) = ( centr(1) + radi*cos(rr) ) ; % xx
    ppr( 2, jj) = ( centr(2) + radi*sin(rr) ) ;
    % pp( 3, jj) = 0;
    % pp( 4, jj) = 1;
end

 %  [ cos(thet)  -sin(thet)  ; sin(thet)  cos(thet) ] ;
[ thetWG ] = TwoD_rot_mat18( thet ) ;

pp_orig = thetWG*ppr;

pp_trans= [pp_orig(1, :)+cent(1)*ones( 1, reso) ; pp_orig( 2, : )+cent(2)*ones( 1, reso) ] ;

figure(2)
plot( pp_trans(1, 1:22), pp_trans(2, 1:22), 'r' )
hold on
plot( pp_trans(1, 23:40), pp_trans(2, 23:40), 'g*' )
axis equal
plot( pp_trans(1, 41:reso), pp_trans(2, 41:reso), 'r' )

axis( [0  11    0  10] );
axis equal

pp2 = pp_trans;
jmp = 0.4;

for kk = 1:25
    %hold off 
    pause(.1)
    pp2 = [ pp2(1, :) + cos(thet)*jmp*ones(1, reso)  ; pp2(2, :) + sin(thet)*jmp*ones(1, reso) ] ;
    plot( pp2(1, 1:22), pp2(2, 1:22), 'r' )
    hold on
    %pause(.1)
    plot( pp2(1, 23:40), pp2(2, 23:40), 'g*' )
    %pause(.1)
    plot( pp2(1, 41:reso), pp2(2, 41:reso), 'r' )
    axis( [0  11    0  10] );
    axis equal
    pause(0.3)
    
    if max(pp2(:, 1) ) > wdth
        condW = 1;
    elseif max(pp2(:, 2) ) > Lngth
        condW = 2;
    elseif min(pp2(:, 1) ) < 0 
        condW = 3;
    elseif min(pp2(:, 2) ) < 0
        condW = 4;
    else
        condW = 0;
    end
    
    if condW > 0
         [ pp2 ] = WallReact18( pp2, condW )
    end
    
    
    pp2 = [ pp2(1, :) - 1.5*cos(thet)*jmp*ones(1, reso)  ; pp2(2, :) - 1.5*sin(thet)*jmp*ones(1, reso) ] ;
    plot( pp2(1, 1:22), pp2(2, 1:22), 'k' )
    hold on
    plot( pp2(1, 23:40), pp2(2, 23:40), 'b*' )
    plot( pp2(1, 41:reso), pp2(2, 41:reso), 'k' )
    axis( [0  11    0  10] );
    axis equal
    wall_flg = 1;
    
end

end % of func




