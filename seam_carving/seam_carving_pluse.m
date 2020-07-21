function run = seam_carving_pluse( I )
    ctimes=input('colume carving times:');
    rtimes=input('row carving times:');
    show_I=I;
    while (ctimes~=double(0)) || (rtimes~=double(0))
        if ctimes~=double(0)
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
            red_line_I=show_I;
            for i=size(I,1)-1:-1:1
                if clm_index(1,i+1)==1
                    if use(i,clm_index(1,i+1)+1)<=use(i,clm_index(1,i+1))
                        red_line_I(i,clm_index(1,i+1)+1,1)=255;
                        I(i,clm_index(1,i+1)+1,1)=255;
                        I(i,clm_index(1,i+1)+1,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)+1;
                        index_img(i,clm_index(1,i+1)+1)=1;
                    else
                        red_line_I(i,clm_index(1,i+1),1)=255;
                        I(i,clm_index(1,i+1),1)=255;
                        I(i,clm_index(1,i+1),2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1);
                        index_img(i,clm_index(1,i+1))=1;
                    end
                elseif clm_index(1,i+1)==size(I,2)
                    if use(i,clm_index(1,i+1))<=use(i,clm_index(1,i+1)-1)
                        red_line_I(i,clm_index(1,i+1),1)=255;
                        I(i,clm_index(1,i+1),1)=255;
                        I(i,clm_index(1,i+1),2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1);
                        index_img(i,clm_index(1,i+1))=1;
                    else
                        red_line_I(i,clm_index(1,i+1)-1,1)=255;
                        I(i,clm_index(1,i+1)-1,1)=255;
                        I(i,clm_index(1,i+1)-1,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)-1;
                        index_img(i,clm_index(1,i+1)-1)=1;
                    end
                else
                    if use(i,clm_index(1,i+1))<=use(i,clm_index(1,i+1)-1)
                        if use(i,clm_index(1,i+1)+1)<=use(i,clm_index(1,i+1))
                            red_line_I(i,clm_index(1,i+1)+1,1)=255;
                            I(i,clm_index(1,i+1)+1,1)=255;
                            I(i,clm_index(1,i+1)+1,2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1)+1;
                            index_img(i,clm_index(1,i+1)+1)=1;
                        else
                            red_line_I(i,clm_index(1,i+1),1)=255;
                            I(i,clm_index(1,i+1),1)=255;
                            I(i,clm_index(1,i+1),2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1);
                            index_img(i,clm_index(1,i+1))=1;
                        end
                    else
                        if use(i,clm_index(1,i+1)-1)<=use(i,clm_index(1,i+1)+1)
                            red_line_I(i,clm_index(1,i+1)-1,1)=255;
                            I(i,clm_index(1,i+1)-1,1)=255;
                            I(i,clm_index(1,i+1)-1,2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1)-1;
                            index_img(i,clm_index(1,i+1)-1)=1;
                        else
                            red_line_I(i,clm_index(1,i+1)+1,1)=255;
                            I(i,clm_index(1,i+1)+1,1)=255;
                            I(i,clm_index(1,i+1)+1,2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1)+1;
                            index_img(i,clm_index(1,i+1)+1)=1;
                        end
                    end
                end
            end
            imshow(red_line_I)
            sh_I=show_I;
            pru_I=I;
            clm = size(I,2);
            for i=size(I,1):-1:1
                if clm_index(1,i)>1
                    sh_I(i,clm_index(1,i),1:3)=uint8( ( double(show_I(i,clm_index(1,i),1:3))+double(show_I(i,clm_index(1,i)-1,1:3)) )/2 );
                    sh_I(i,clm_index(1,i)+1:clm+1,1:3)=show_I(i,clm_index(1,i):clm,1:3);
                    pru_I(i,clm_index(1,i),1:3)=( double(I(i,clm_index(1,i),1:3))+double(I(i,clm_index(1,i)-1,1:3)) )/2;
                    pru_I(i,clm_index(1,i)+1:clm+1,1:3)=I(i,clm_index(1,i):clm,1:3);
                else
                    sh_I(i,clm_index(1,i),1:3)=uint8( ( double(show_I(i,clm_index(1,i),1:3))+double(show_I(i,clm_index(1,i)+1,1:3)) )/2 );
                    sh_I(i,clm_index(1,i)+1:clm+1,1:3)=show_I(i,clm_index(1,i):clm,1:3);
                    pru_I(i,clm_index(1,i),1:3)=( double(I(i,clm_index(1,i),1:3))+double(I(i,clm_index(1,i)+1,1:3)) )/2;
                    pru_I(i,clm_index(1,i)+1:clm+1,1:3)=I(i,clm_index(1,i):clm,1:3);
                end
            end
            show_I=sh_I;
            I=pru_I;
            imshow(sh_I)
            ctimes=ctimes-1;
        end
        if rtimes~=double(0)
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
            clm_index=zeros(1,size(I,2));        
            minn=use(1,size(I,2));
            clm_index(1,size(I,2))=1;
            for j=2:size(I,1)
                if use(j,size(I,2))<minn
                    minn=use(j,size(I,2));
                    clm_index(1,size(I,2))=j;
                end
            end
            red_line_I=show_I;
            for i=size(I,2)-1:-1:1
                if clm_index(1,i+1)==1
                    if use(clm_index(1,i+1)+1,i)<=use(clm_index(1,i+1),i)
                        red_line_I(clm_index(1,i+1)+1,i,1)=255;
                        I(clm_index(1,i+1)+1,i,1)=255;
                        I(clm_index(1,i+1)+1,i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)+1;
                    else
                        red_line_I(clm_index(1,i+1),i,1)=255;
                        I(clm_index(1,i+1),i,1)=255;
                        I(clm_index(1,i+1),i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1);
                    end
                elseif clm_index(1,i+1)==size(I,1)
                    if use(clm_index(1,i+1),i)<=use(clm_index(1,i+1)-1,i)
                        red_line_I(clm_index(1,i+1),i,1)=255;
                        I(clm_index(1,i+1),i,1)=255;
                        I(clm_index(1,i+1),i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1);
                    else
                        red_line_I(clm_index(1,i+1)-1,i,1)=255;
                        I(clm_index(1,i+1)-1,i,1)=255;
                        I(clm_index(1,i+1)-1,i,2:3)=0;
                        clm_index(1,i)=clm_index(1,i+1)-1;
                    end
                else
                    if use(clm_index(1,i+1),i)<=use(clm_index(1,i+1)-1,i)
                        if use(clm_index(1,i+1)+1,i)<=use(clm_index(1,i+1),i)
                            red_line_I(clm_index(1,i+1)+1,i,1)=255;
                            I(clm_index(1,i+1)+1,i,1)=255;
                            I(clm_index(1,i+1)+1,i,2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1)+1;
                        else
                            red_line_I(clm_index(1,i+1),i,1)=255;
                            I(clm_index(1,i+1),i,1)=255;
                            I(clm_index(1,i+1),i,2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1);
                        end
                    else
                        if use(clm_index(1,i+1)-1,i)<=use(clm_index(1,i+1)+1,i)
                            red_line_I(clm_index(1,i+1)-1,i,1)=255;
                            I(clm_index(1,i+1)-1,i,1)=255;
                            I(clm_index(1,i+1)-1,i,2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1)-1;
                        else
                            red_line_I(clm_index(1,i+1)+1,i,1)=255;
                            I(clm_index(1,i+1)+1,i,1)=255;
                            I(clm_index(1,i+1)+1,i,2:3)=0;
                            clm_index(1,i)=clm_index(1,i+1)+1;
                        end
                    end
                end
            end
            imshow(red_line_I)
            pru_I=I;
            sh_I=show_I;
            clm = size(show_I,1);
            for i=size(I,2):-1:1
                if clm_index(1,i)>1
                    sh_I(clm_index(1,i),i,1:3)=uint8( ( double(show_I(clm_index(1,i),i,1:3))+double(show_I(clm_index(1,i)-1,i,1:3)) )/2 );
                    sh_I(clm_index(1,i)+1:clm+1,i,1:3)=show_I(clm_index(1,i):clm,i,1:3);
                    pru_I(clm_index(1,i),i,1:3)=uint8( ( double(I(clm_index(1,i),i,1:3))+double(I(clm_index(1,i)-1,i,1:3)) )/2 );
                    pru_I(clm_index(1,i)+1:clm+1,i,1:3)=I(clm_index(1,i):clm,i,1:3);
                else
                    sh_I(clm_index(1,i),i,1:3)=uint8( ( double(show_I(clm_index(1,i),i,1:3))+double(show_I(clm_index(1,i)+1,i,1:3)) )/2 );
                    sh_I(clm_index(1,i)+1:clm+1,i,1:3)=show_I(clm_index(1,i):clm,i,1:3);
                    pru_I(clm_index(1,i),i,1:3)=uint8( ( double(I(clm_index(1,i),i,1:3))+double(I(clm_index(1,i)+1,i,1:3)) )/2 );
                    pru_I(clm_index(1,i)+1:clm+1,i,1:3)=I(clm_index(1,i):clm,i,1:3);
                end
            end
            I=pru_I;
            show_I=sh_I;
            imshow(show_I)
            rtimes=rtimes-1;
        end
    end
    run = 0;
end