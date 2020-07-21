clear 
clc
I = imread('penguins.jpg');
% figure
% imshowpair(Gmag, Gdir, 'montage');
% title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')
% doc imgradient
% imagesc(Gmag)
ctimes=input('colume carving times:')
rtimes=input('row carving times:')
vanish = roipoly(I);
while (ctimes~=double(0)) || (rtimes~=double(0))
    if ctimes~=double(0)
        img_Gray=rgb2gray(I);
        [Gmag,Gdir] = imgradient(img_Gray, 'prewitt');
        use=Gmag;
        max_val = max( max( use, [], 1), [], 2);
        use(find(vanish==1))=max_val+1;
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
        clm_index=zeros(1,size(I,1));
        index_img=zeros(size(I,1),size(I,2));
        
        minn=use(size(I,1),1);
        clm_index(1,size(I,1))=1;
        for j=2:size(I,2)
            if use(size(I,1),j)<minn
                minn=use(size(I,1),j);
                clm_index(1,size(I,1))=j;
            end
        end
        index_img(size(I,1),clm_index(1,size(I,1)))=1;
        for i=size(I,1)-1:-1:1
            if clm_index(1,i+1)==1
                if use(i,clm_index(1,i+1)+1)<=use(i,clm_index(1,i+1))
                    I(i,clm_index(1,i+1)+1,1)=255;
                    I(i,clm_index(1,i+1)+1,2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1)+1;
                    index_img(i,clm_index(1,i+1)+1)=1;
                else
                    I(i,clm_index(1,i+1),1)=255;
                    I(i,clm_index(1,i+1),2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1);
                    index_img(i,clm_index(1,i+1))=1;
                end
            elseif clm_index(1,i+1)==size(I,2)
                if use(i,clm_index(1,i+1))<=use(i,clm_index(1,i+1)-1)
                    I(i,clm_index(1,i+1),1)=255;
                    I(i,clm_index(1,i+1),2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1);
                    index_img(i,clm_index(1,i+1))=1;
                else
                    I(i,clm_index(1,i+1)-1,1)=255;
                    I(i,clm_index(1,i+1)-1,2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1)-1;
                    index_img(i,clm_index(1,i+1)-1)=1;
                end
            else
                if use(i,clm_index(1,i+1))<=use(i,clm_index(1,i+1)-1)
                    if use(i,clm_index(1,i+1)+1)<=use(i,clm_index(1,i+1))
                        I(i,clm_index(1,i+1)+1,1)=255;
                        I(i,clm_index(1,i+1)+1,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)+1;
                        index_img(i,clm_index(1,i+1)+1)=1;
                    else
                        I(i,clm_index(1,i+1),1)=255;
                        I(i,clm_index(1,i+1),2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1);
                        index_img(i,clm_index(1,i+1))=1;
                    end
                else
                    if use(i,clm_index(1,i+1)-1)<=use(i,clm_index(1,i+1)+1)
                        I(i,clm_index(1,i+1)-1,1)=255;
                        I(i,clm_index(1,i+1)-1,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)-1;
                        index_img(i,clm_index(1,i+1)-1)=1;
                    else
                        I(i,clm_index(1,i+1)+1,1)=255;
                        I(i,clm_index(1,i+1)+1,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)+1;
                        index_img(i,clm_index(1,i+1)+1)=1;
                    end
                end
            end
        end
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
        ctimes=ctimes-1;
        if sum(sum(vanish(1:end,1),2) == size(vanish,1)*size(vanish,2)
            ctimes=0;
        end
    end
    if rtimes~=double(0)
        img_Gray=rgb2gray(I);%row
        [Gmag,Gdir] = imgradient(img_Gray, 'prewitt');
        use=Gmag;
        max_val = max( max( use, [], 1), [], 2);
        use(find(vanish==1))=max_val+1;
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
        clm_index=zeros(1,size(I,2));        
        minn=use(1,size(I,2));
        clm_index(1,size(I,2))=1;
        for j=2:size(I,1)
            if use(j,size(I,2))<minn
                minn=use(j,size(I,2));
                clm_index(1,size(I,2))=j;
            end
        end
        for i=size(I,2)-1:-1:1
            if clm_index(1,i+1)==1
                if use(clm_index(1,i+1)+1,i)<=use(clm_index(1,i+1),i)
                    I(clm_index(1,i+1)+1,i,1)=255;
                    I(clm_index(1,i+1)+1,i,2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1)+1;
                else
                    I(clm_index(1,i+1),i,1)=255;
                    I(clm_index(1,i+1),i,2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1);
                end
            elseif clm_index(1,i+1)==size(I,1)
                if use(clm_index(1,i+1),i)<=use(clm_index(1,i+1)-1,i)
                    I(clm_index(1,i+1),i,1)=255;
                    I(clm_index(1,i+1),i,2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1);
                else
                    I(clm_index(1,i+1)-1,i,1)=255;
                    I(clm_index(1,i+1)-1,i,2:3)=0;
                    clm_index(1,i)=clm_index(1,i+1)-1;
                end
            else
                if use(clm_index(1,i+1),i)<=use(clm_index(1,i+1)-1,i)
                    if use(clm_index(1,i+1)+1,i)<=use(clm_index(1,i+1),i)
                        I(clm_index(1,i+1)+1,i,1)=255;
                        I(clm_index(1,i+1)+1,i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)+1;
                    else
                        I(clm_index(1,i+1),i,1)=255;
                        I(clm_index(1,i+1),i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1);
                    end
                else
                    if use(clm_index(1,i+1)-1,i)<=use(clm_index(1,i+1)+1,i)
                        I(clm_index(1,i+1)-1,i,1)=255;
                        I(clm_index(1,i+1)-1,i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)-1;
                    else
                        I(clm_index(1,i+1)+1,i,1)=255;
                        I(clm_index(1,i+1)+1,i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)+1;
                    end
                end
            end
        end
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
        rtimes=rtimes-1;
    end
    if sum(sum(vanish,1),2) == size(vanish,1)*size(vanish,2)
            rtimes=0;
    end
end
