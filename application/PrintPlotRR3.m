function  PrintPlotRR3(bool1,bool2,bool3,bool4,radi,pp,ang_vec, reso, pp2, cent_mat, feeld, kk, NN,energy )
% rev 3 7.20.18 print all 4 of the pp array
% 7.18.18 update for 3 drones blue + 
% July 2, no new fig 
%June 30, 2018 print the RR in the field. 
%   

for qq = 1:NN
    rot_mat(:, :, qq)  = TwoD_rot_mat18( ang_vec(qq) ) ;
    pp2(:, :, qq) = rot_mat(:, :, qq) * pp(:,  :, qq) ;
    
    pp2(:, :, qq) = pp2(:, :, qq) + repmat( cent_mat(:, qq), 1, reso ) ; % yes, group add works
end

br_strt = (reso-1)/4+2;
back_rnge = [ (br_strt : reso-br_strt+1 ) ] ;

    fill([0 feeld(1) feeld(1) 0],[feeld(2) feeld(2) 0 0], [0.2, 0.7450, 0.9330]);

    hold on
    if bool1 == 0
    plot( pp2(1,1:br_strt-1, 1), pp2(2,1:br_strt-1, 1), 'k.' )
    plot( pp2(1, br_strt:br_strt*2,1), pp2(2, br_strt:br_strt*2, 1), 'gd' ) % astrick
    plot( pp2(1, br_strt*2+1:end, 1 ), pp2(2, br_strt*2+1:end, 1), 'k.' )
    plot(cent_mat(1, 1), cent_mat(2, 1), 'kx' )
    end
    if bool2 ==0
    plot( pp2(1,1:br_strt-1, 2), pp2(2,1:br_strt-1, 2), 'k.' )
    plot( pp2(1, br_strt:br_strt*2, 2), pp2(2, br_strt:br_strt*2, 2), 'rp' )
    plot( pp2(1, br_strt*2+1:end, 2 ), pp2(2, br_strt*2+1:end, 2), 'k.' )
    plot(cent_mat(1, 2), cent_mat(2, 2), 'kx' )
    end
    if bool3 == 0
    plot( pp2(1,1:br_strt-1, 3), pp2(2,1:br_strt-1, 3), 'k.' )
    plot( pp2(1, br_strt:br_strt*2, 3), pp2(2, br_strt:br_strt*2, 3), 'b+' )
    plot( pp2(1, br_strt*2+1:end, 3 ), pp2(2, br_strt*2+1:end, 3), 'k.' )
    plot(cent_mat(1, 3), cent_mat(2, 3), 'kx' )
    end
    if bool4 == 0
    plot( pp2(1,1:br_strt-1, 4), pp2(2,1:br_strt-1, 4), 'k.' )
    plot( pp2(1, br_strt:br_strt*2, 4), pp2(2, br_strt:br_strt*2, 4), 'm^' )
    plot( pp2(1, br_strt*2+1:end, 4 ), pp2(2, br_strt*2+1:end, 4), 'k.' )
    plot(cent_mat(1, 4), cent_mat(2, 4), 'kx' )
    end

plot( [ 0 feeld(1) ] , [feeld(2)  feeld(2) ] , 'k')
plot(  [feeld(1) feeld(1) ] , [ 0 feeld(2) ] , 'k')
plot(  [ 0 0 ] , [ 0 feeld(2) ] , 'k')
plot( [0 feeld(1)], [0 0], 'k')
axis equal
delete(findall(gcf,'Tag','stream'));
        dim = [0, 0.925, 0, 0];
        str = {'Energy',energy(1),energy(2),energy(3),energy(4)};
        annotation('textbox',dim,'String',str,'FitBoxToText','on','Tag','stream');

set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'xtick',[])
set(gca,'ytick',[])
%set(gca,'visible','off'); %toggle this
title(kk);
text([feeld(2)/2],[-3],'Wonderful Game','HorizontalAlignment','center','FontSize',18);
%hold off 

end

