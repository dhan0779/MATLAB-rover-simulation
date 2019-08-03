function [ pp2, cent_mat, ang_vec ] = MoveOnWG18J(pp2, cent_mat, ang_vec, reso, jmp, feeld, alph1, alph2, NN, BUstp, Only2, NoRnd, kk )
% rev J fix double backup with Rot_sub_Cent2 
% 7.31.18 rev H incorp RRU 
% 7.29.18 during Only2 have wall contact rotate to center
% incorp backup if wall hit 7.27.18 
% 7.20.18 for Obj Ori rev ofpp2
% rev D, become code for one rover at a time
% rev C, July 1, 2018 use elseif
% expand switch to other conditions 6,30
% 6.29.18 move forward and rotate off walls...hit right wall going up
% no Snell's law here
% limit of ang is 0 to 2*pi

ang = ang_vec ; 
condW = 0;



condA = 0;
for dd = 1:NN
    ang(dd) = ang(dd) + 2*pi ;
    ang(dd) = rem(ang(dd), 2*pi) ; 
    
    pp2(:, :, dd) = [pp2(1, :, dd) + cos(ang(dd))*jmp(dd)*ones(1, reso)  ; pp2(2, :, dd) + sin(ang(dd))*jmp(dd)*ones(1, reso) ] ;
    cent_mat(:, dd) = [ cent_mat(1, dd) + cos(ang(dd))*jmp(dd) ;  cent_mat(2, dd) + sin(ang(dd))*jmp(dd) ]  ;
    % just moves forward in direction of current ang... then rotates if 
    
    % hitting which wall of 4
    if max(pp2(1, :, dd) ) > feeld(1) % right
        condW = 1;
    elseif max(pp2(2, :, dd) ) > feeld(2) % up 
        condW = 2;
    elseif min(pp2(1, :, dd) ) < 0  % left 
        condW = 3;
    elseif min(pp2(2, :, dd) ) < 0  % down 
        condW = 4;
    else
        condW = 0;
    end
    
    if condW ~= 0
        % condition angle
        if ang(dd) >= 0 && ang(dd) <= pi/2 % && ang(dd) > 0 upper right 
            condA = 1;
        elseif  ang(dd) > pi/2 && ang(dd) <= pi % upper left 
            condA = 2;
        elseif ang(dd) > pi && ang(dd) <= pi*3/2 % lower left 
            condA = 3;
        elseif ang(dd) > (3/2)*pi && ang(dd) <= 2*pi % lower right
            condA = 4;
        else
            condA = 0;
        end
        
        % below is backup for all... 
        rev_ang = ang +pi;
        rev_ang = rem(rev_ang, 2*pi) ;
        pp2(:, :, dd) = [pp2(1, :, dd) + cos(rev_ang(dd))*BUstp(dd)*ones(1, reso)  ; pp2(2, :, dd) + sin(rev_ang(dd))*BUstp(dd)*ones(1, reso) ] ;
        cent_mat(:, dd) = [ cent_mat(1, dd) + cos(rev_ang(dd))*BUstp(dd) ;  cent_mat(2, dd) + sin(rev_ang(dd))*BUstp(dd) ]  ;
        load H:/Documents/MATLAB/DahTah/WGdata18/BlkHole40 %only2
        if Only2 == 1  % angle to center
           
           % alph1 and alph2 came by way of argin... and exerNNroversX
           switch NoRnd
              case 0
                 ndx17 = ceil(rand(1)*reso); % random point on pp2(:, :, dd) ;
                 load H:/Documents/MATLAB/DahTah/WGdata18/RRU
                 RandRoundUp(kk, 4) = ndx17;
                 save H:/Documents/MATLAB/DahTah/WGdata18/RRU RandRoundUp
              case 2
                 load H:/Documents/MATLAB/DahTah/WGdata18/RRU
                 ndx17 = RandRoundUp(kk, 4) ; 
           end         
           
           ang2cent = atan2( [ feeld(2)/2 - pp2(2, ndx17, dd) ], [ feeld(1)/2 - pp2(1, ndx17, dd) ] ) ;
           del_ang_raw =  ang2cent - ang(dd);
           del_ang = rem(del_ang_raw+2*pi, 2*pi) * 0.96 ;  % separate jousting 
        end

        if condW == 1 && condA == 1 % R side, Up CCW
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph1 ) ;
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end

        elseif condW == 1 && condA == 4 % R side, Down CW
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph2 ) ;
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end

        elseif condW == 2 && condA == 2 % Top, Left CCW
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph1  ) ;
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end

        elseif condW == 2 && condA == 1 % Top, Right
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph2 ) ;
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end

        elseif condW == 3 && condA == 2 % Left side UP
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph2  );
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end

        elseif condW == 3 && condA == 3 %  Left side down CCW
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph1  ) ;
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end

        elseif condW == 4 && condA == 4 % Bottom, going Right down CCW
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph1  ) ;
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end

        elseif condW == 4 && condA == 3 % Bottom going Left
           if Only2 == 0
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent2(pp2(:,:, dd), cent_mat(:, dd), ang(dd), alph2  );
           else
              [pp2(:,:, dd), cent_mat(:, dd), ang(dd) ] = Rot_sub_Cent(pp2(:,:, dd), cent_mat(:, dd), ang(dd), reso, del_ang, jmp(dd) ) ;
           end
        end
    end
end%condW ~= 0
ang_vec = ang; 

end % of function


