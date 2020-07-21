function run = seam_carving_punish_remove( I )
    mode = input("colume mode = 0 , row mode = 1 , all = 2 :");
    figure(1),subplot(223),imshow(I)
    vanish = roipoly(I);
    times=sum(sum(vanish,1),2);
    while (times>0)
        img_Gray=rgb2gray(I);
        [Gmag,Gdir] = imgradient(img_Gray, 'prewitt');
        use_ori=Gmag;
        use=double(img_Gray);
        use_pixel=use;
        for i=2:size(I,1)
            for j=1:size(I,2)
                if j==1
                    punish_R = abs( use_pixel(i-1,j)-use_pixel(i,j+1) );
                    use(i,j)=use(i,j)+min(use(i-1,j),use(i-1,j+1)+punish_R);
                    use_ori(i,j)=use_ori(i,j)+min(use_ori(i-1,j),use_ori(i-1,j+1));
                elseif j==size(I,2)
                    punish_L = abs( use_pixel(i-1,j)-use_pixel(i,j-1) );
                    use(i,j)=use(i,j)+min(use(i-1,j-1)+punish_L,use(i-1,j));
                    use_ori(i,j)=use_ori(i,j)+min(use_ori(i-1,j-1),use_ori(i-1,j));
                else
                    punish_L = abs( use_pixel(i,j-1)-use_pixel(i,j+1) )+abs( use_pixel(i-1,j)-use_pixel(i,j-1) );
                    punish_V = abs( use_pixel(i,j-1)-use_pixel(i,j+1) );
                    punish_R = abs( use_pixel(i,j-1)-use_pixel(i,j+1) )+abs( use_pixel(i-1,j)-use_pixel(i,j+1) );
                    use(i,j)=use(i,j)+min(min(use(i-1,j-1)+punish_L,use(i-1,j)+punish_V),use(i-1,j+1)+punish_R);
                    use_ori(i,j)=use_ori(i,j)+min(min(use_ori(i-1,j-1),use_ori(i-1,j)),use_ori(i-1,j+1));
                end
            end
        end
        figure(1),subplot(221),imagesc(use_ori)
        figure(1),subplot(222),imagesc(use)
        if mode~=1                       
            %start choice line
            use(find(vanish==1))=0;
            highi=1;
            smallj=size(I,2);
            for j=size(I,2):-1:1
                for i=1:size(I,1)
                    if vanish(i,j)==1
                        if i>=highi
                            highi=i;
                            smallj=j;
                        elseif j<smallj
                            highi=i;
                            smallj=j;
                        end
                    end
                end
            end
            up=highi-1;
            down=highi;
            clm_index=zeros(1,size(I,1));
            clm_index(1,down)=smallj;
            while (up>=1) || (down<size(I,1))
                if up>=1
                    if clm_index(1,up+1)==1
                        if use(up,clm_index(1,up+1)+1)<use(up,clm_index(1,up+1))
                            I(up,clm_index(1,up+1)+1,1)=255;
                            I(up,clm_index(1,up+1)+1,2:3)=0;
                            vanish(up,clm_index(1,up+1)+1)=0;             
                        else
                            I(up,clm_index(1,up+1),1)=255;
                            I(up,clm_index(1,up+1),2:3)=0;
                            clm_index(1,up)=clm_index(1,up+1);
                            vanish(up,clm_index(1,up+1))=0;
                        end
                    elseif clm_index(1,up+1)==size(I,2)
                        if use(up,clm_index(1,up+1))<use(up,clm_index(1,up+1)-1)
                            I(up,clm_index(1,up+1),1)=255;
                            I(up,clm_index(1,up+1),2:3)=0;
                            clm_index(1,up)=clm_index(1,up+1);
                            vanish(up,clm_index(1,up+1))=0;
                        else
                            I(up,clm_index(1,up+1)-1,1)=255;
                            I(up,clm_index(1,up+1)-1,2:3)=0;
                            clm_index(1,up)=clm_index(1,up+1)-1;
                            vanish(up,clm_index(1,up+1)-1)=0;
                        end
                    else
                        if use(up,clm_index(1,up+1))<use(up,clm_index(1,up+1)-1)
                            if use(up,clm_index(1,up+1)+1)<use(up,clm_index(1,up+1))
                                I(up,clm_index(1,up+1)+1,1)=255;
                                I(up,clm_index(1,up+1)+1,2:3)=0;
                                clm_index(1,up)=clm_index(1,up+1)+1;
                                vanish(up,clm_index(1,up+1)+1)=0;
                            else
                                I(up,clm_index(1,up+1),1)=255;
                                I(up,clm_index(1,up+1),2:3)=0;
                                clm_index(1,up)=clm_index(1,up+1);
                                vanish(up,clm_index(1,up+1))=0;
                            end
                        else
                            if use(up,clm_index(1,up+1)-1)<=use(up,clm_index(1,up+1)+1)
                                I(up,clm_index(1,up+1)-1,1)=255;
                                I(up,clm_index(1,up+1)-1,2:3)=0;
                                clm_index(1,up)=clm_index(1,up+1)-1;
                                vanish(up,clm_index(1,up+1)-1)=0;
                            else
                                I(up,clm_index(1,up+1)+1,1)=255;
                                I(up,clm_index(1,up+1)+1,2:3)=0;
                                clm_index(1,up)=clm_index(1,up+1)+1;
                                vanish(up,clm_index(1,up+1)+1)=0;
                            end
                        end
                    end
                    up=up-1;
                end
                if down<size(I,1)
                    if clm_index(1,down)==1
                        if use(down+1,clm_index(1,down)+1)<use(down+1,clm_index(1,down))
                            I(down+1,clm_index(1,down)+1,1)=255;
                            I(down+1,clm_index(1,down)+1,2:3)=0;
                            clm_index(1,down+1)=clm_index(1,down)+1;
                            vanish(down+1,clm_index(1,down)+1)=0;
                        else
                            I(down+1,clm_index(1,down),1)=255;
                            I(down+1,clm_index(1,down),2:3)=0;
                            clm_index(1,down+1)=clm_index(1,down);
                            vanish(down+1,clm_index(1,down))=0;
                        end
                    elseif clm_index(1,down)==size(I,2)
                        if use(down+1,clm_index(1,down))<use(down,clm_index(1,down)-1)
                            I(down+1,clm_index(1,down),1)=255;
                            I(down+1,clm_index(1,down),2:3)=0;
                            clm_index(1,down+1)=clm_index(1,down);
                            vanish(down+1,clm_index(1,down))=0;
                        else
                            I(down+1,clm_index(1,down)-1,1)=255;
                            I(down+1,clm_index(1,down)-1,2:3)=0;
                            clm_index(1,down+1)=clm_index(1,down)-1;
                            vanish(down+1,clm_index(1,down)-1)=0;
                        end
                    else
                        if use(down+1,clm_index(1,down))<use(down+1,clm_index(1,down)-1)
                            if use(down+1,clm_index(1,down)+1)<use(down+1,clm_index(1,down))
                                I(down+1,clm_index(1,down)+1,1)=255;
                                I(down+1,clm_index(1,down)+1,2:3)=0;
                                clm_index(1,down+1)=clm_index(1,down)+1;
                                vanish(down+1,clm_index(1,down)+1)=0;
                            else
                                I(down+1,clm_index(1,down),1)=255;
                                I(down+1,clm_index(1,down),2:3)=0;
                                clm_index(1,down+1)=clm_index(1,down);
                                vanish(down+1,clm_index(1,down))=0;
                            end
                        else
                            if use(down+1,clm_index(1,down)-1)<=use(down+1,clm_index(1,down)+1)
                                I(down+1,clm_index(1,down)-1,1)=255;
                                I(down+1,clm_index(1,down)-1,2:3)=0;
                                clm_index(1,down+1)=clm_index(1,down)-1;
                                vanish(down+1,clm_index(1,down)-1)=0;
                            else
                                I(down+1,clm_index(1,down)+1,1)=255;
                                I(down+1,clm_index(1,down)+1,2:3)=0;
                                clm_index(1,down+1)=clm_index(1,down)+1;
                                vanish(down+1,clm_index(1,down)+1)=0;
                            end
                        end
                    end
                    down=down+1;
                end
            end
            %over
            figure(1),subplot(224),imshow(I)
            pru_I=I;
            pru_van=vanish;
            for i=size(I,1):-1:1
                pru_I(i,clm_index(1,i):size(I,2)-1,1:3)=I(i,clm_index(1,i)+1:size(I,2),1:3);
                pru_I(i,size(I,2),1:3)=0;
                pru_van(i,clm_index(1,i):size(I,2)-1)=pru_van(i,clm_index(1,i)+1:size(I,2));
                pru_van(i,size(I,2))=0;
            end
            I=[];
            I=pru_I(:,1:size(pru_I,2)-1,:);
            vanish=pru_van(:,1:size(pru_I,2)-1);           
            figure(1),subplot(224),imshow(I)
        end
        if mode~=0
            %start choice line
            use(find(vanish==1))=0;
            highi=1;
            smallj=size(I,2);
            for j=size(I,2):-1:1
                for i=1:size(I,1)
                    if vanish(i,j)==1
                        if i>=highi
                            highi=i;
                            smallj=j;
                        elseif j<smallj
                            highi=i;
                            smallj=j;
                        end
                    end
                end
            end
            left=smallj-1;
            right=smallj;
            clm_index=zeros(1,size(I,2));
            clm_index(1,right)=highi;
            while (left>=1) || (right<size(I,2))
                if left>=1
                    if clm_index(1,left+1)==1
                        if use(clm_index(1,left+1)+1,left)<=use(clm_index(1,left+1),left)
                            I(clm_index(1,left+1)+1,left,1)=255;
                            I(clm_index(1,left+1)+1,left,2:3)=0;
                            clm_index(1,left)=clm_index(1,left+1)+1;
                            vanish(clm_index(1,left+1)+1,left)=0;
                        else
                            I(clm_index(1,left+1),left,1)=255;
                            I(clm_index(1,left+1),left,2:3)=0;
                            clm_index(1,left)=clm_index(1,left+1);
                            vanish(clm_index(1,left+1),left)=0;
                        end
                    elseif clm_index(1,left+1)==size(I,1)
                        if use(clm_index(1,left+1),left)<=use(clm_index(1,left+1)-1,left)
                            I(clm_index(1,left+1),left,1)=255;
                            I(clm_index(1,left+1),left,2:3)=0;
                            clm_index(1,left)=clm_index(1,left+1);
                            vanish(clm_index(1,left+1),left)=0;
                        else
                            I(clm_index(1,left+1)-1,left,1)=255;
                            I(clm_index(1,left+1)-1,left,2:3)=0;
                            clm_index(1,left)=clm_index(1,left+1)-1;
                            vanish(clm_index(1,left+1)-1,left)=0;
                        end
                    else
                        if use(clm_index(1,left+1),left)<=use(clm_index(1,left+1)-1,left)
                            if use(clm_index(1,left+1)+1,left)<=use(clm_index(1,left+1),left)
                                I(clm_index(1,left+1)+1,left,1)=255;
                                I(clm_index(1,left+1)+1,left,2:3)=0;
                                clm_index(1,left)=clm_index(1,left+1)+1;
                                vanish(clm_index(1,left+1)+1,left)=0;
                            else
                                I(clm_index(1,left+1),left,1)=255;
                                I(clm_index(1,left+1),left,2:3)=0;
                                clm_index(1,left)=clm_index(1,left+1);
                                vanish(clm_index(1,left+1),left)=0;
                            end
                        else
                            if use(clm_index(1,left+1)-1,left)<use(clm_index(1,left+1)+1,left)
                                I(clm_index(1,left+1)-1,left,1)=255;
                                I(clm_index(1,left+1)-1,left,2:3)=0;
                                clm_index(1,left)=clm_index(1,left+1)-1;
                                vanish(clm_index(1,left+1)-1,left)=0;
                            else
                                I(clm_index(1,left+1)+1,left,1)=255;
                                I(clm_index(1,left+1)+1,left,2:3)=0;
                                clm_index(1,left)=clm_index(1,left+1)+1;
                                vanish(clm_index(1,left+1)+1,left)=0;
                            end
                        end
                    end
                    left=left-1;
                end
                if right<size(I,2)
                    if clm_index(1,right)==1
                        if use(clm_index(1,right)+1,right+1)<=use(clm_index(1,right),right+1)
                            I(clm_index(1,right)+1,right+1,1)=255;
                            I(clm_index(1,right)+1,right+1,2:3)=0;
                            clm_index(1,right+1)=clm_index(1,right)+1;
                            vanish(clm_index(1,right)+1,right+1)=0;
                        else
                            I(clm_index(1,right),right+1,1)=255;
                            I(clm_index(1,right),right+1,2:3)=0;
                            clm_index(1,right+1)=clm_index(1,right);
                            vanish(clm_index(1,right),right+1)=0;
                        end
                    elseif clm_index(1,right)==size(I,1)
                        if use(clm_index(1,right),right+1)<=use(clm_index(1,right)-1,right+1)
                            I(clm_index(1,right),right+1,1)=255;
                            I(clm_index(1,right),right+1,2:3)=0;
                            clm_index(1,right+1)=clm_index(1,right);
                            vanish(clm_index(1,right),right+1)=0;
                        else
                            I(clm_index(1,right)-1,right+1,1)=255;
                            I(clm_index(1,right)-1,right+1,2:3)=0;
                            clm_index(1,right+1)=clm_index(1,right)-1;
                            vanish(clm_index(1,right)-1,right+1)=0;
                        end
                    else
                        if use(clm_index(1,right),right+1)<=use(clm_index(1,right)-1,right+1)
                            if use(clm_index(1,right)+1,right+1)<=use(clm_index(1,right),right+1)
                                I(clm_index(1,right)+1,right+1,1)=255;
                                I(clm_index(1,right)+1,right+1,2:3)=0;
                                clm_index(1,right+1)=clm_index(1,right)+1;
                                vanish(clm_index(1,right)+1,right+1)=0;
                            else
                                I(clm_index(1,right),right+1,1)=255;
                                I(clm_index(1,right),right+1,2:3)=0;
                                clm_index(1,right+1)=clm_index(1,right);
                                vanish(clm_index(1,right),right+1)=0;
                            end
                        else
                            if use(clm_index(1,right)-1,right+1)<use(clm_index(1,right)+1,right+1)
                                I(clm_index(1,right)-1,right+1,1)=255;
                                I(clm_index(1,right)-1,right+1,2:3)=0;
                                clm_index(1,right+1)=clm_index(1,right)-1;
                                vanish(clm_index(1,right)-1,right+1)=0;
                            else
                                I(clm_index(1,right)+1,right+1,1)=255;
                                I(clm_index(1,right)+1,right+1,2:3)=0;
                                clm_index(1,right+1)=clm_index(1,right)+1;
                                vanish(clm_index(1,right)+1,right+1)=0;
                            end
                        end
                    end
                    right=right+1;
                end
            end
            %over   
            figure(1),subplot(224),imshow(I)
            pru_I=I;
            pru_van=vanish;
            for i=size(I,2):-1:1
                pru_I(clm_index(1,i):size(I,1)-1,i,1:3)=I(clm_index(1,i)+1:size(I,1),i,1:3);
                pru_I(size(I,1),i,1:3)=0;
                pru_van(clm_index(1,i):size(I,1)-1,i)=pru_van(clm_index(1,i)+1:size(I,1),i);
                pru_van(size(I,1),i)=0;
            end
            I=[];
            I=pru_I(1:size(pru_I,1)-1,:,:);
            vanish=pru_van(1:size(pru_I,1)-1,:);
            figure(1),subplot(224),imshow(I)
        end
        times=sum(sum(vanish,1),2);
    end
    run=0;
end