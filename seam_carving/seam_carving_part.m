clear 
clc
I = imread('penguins.jpg');
% figure
% imshowpair(Gmag, Gdir, 'montage');
% title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')
% doc imgradient
% imagesc(Gmag)
imshow(I)
vanish = roipoly(I);
times=sum(sum(vanish,1),2);
%mode = input("colume mode = 0 , row mode = 1 , all = 2 :");
mode=2;
while (times>0)
    if mode~=1
        img_Gray=rgb2gray(I);
        [Gmag,Gdir] = imgradient(img_Gray, 'prewitt');
        use=Gmag;
        for i=2:size(I,1)
            for j=1:size(I,2)
                if j==1
                    use(i,j)=use(i,j)+min(use(i-1,j),use(i-1,j+1));
                elseif j==size(I,2)
                    use(i,j)=use(i,j)+min(use(i-1,j-1),use(i-1,j));
                else
                    use(i,j)=use(i,j)+min(min(use(i-1,j-1),use(i-1,j)),use(i-1,j+1));
                end
            end
        end
        imagesc(use);
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
        
        imshow(I)
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
        imshow(I)
    end
    if mode~=0
        img_Gray=rgb2gray(I);%row
        [Gmag,Gdir] = imgradient(img_Gray, 'prewitt');
        use=Gmag;
        for j=2:size(I,2)
            for i=1:size(I,1)
                if i==1
                    use(i,j)=use(i,j)+min(use(i,j-1),use(i+1,j-1));
                elseif i==size(I,1)
                    use(i,j)=use(i,j)+min(use(i-1,j-1),use(i,j-1));
                else
                    use(i,j)=use(i,j)+min(min(use(i-1,j-1),use(i,j-1)),use(i+1,j-1));
                end
            end
        end
        imagesc(use);
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
        imshow(I)
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
        imshow(I)
    end
    times=sum(sum(vanish,1),2);
end
%%
state1=I(:,:,1);
len=length(find(index_img==1));
state1(find(index_img==1))=[];
state1=reshape(state1,286,467);
state2=I(:,:,2);
state2(find(index_img==1))=[];
state2=reshape(state2,286,467);
state3=I(:,:,3);
state3(find(index_img==1))=[];
state3=reshape(state3,286,467);
Image=zeros(286,467,3);
Image(:,:,1)=state1;
Image(:,:,2)=state2;
Image(:,:,3)=state3;
imshow(uint8(Image));

%%
a=[0 1 3;1 2 0;0 3 2;1 0 4];

a(find(a==0))=[];

a=reshape(a,4,2)