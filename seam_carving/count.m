%count colume minimax line
        count=zeros(1,size(I,2));
        clm_index=zeros(size(I,2),size(I,1));
        clm_index(1:end,end)=1:size(I,2);
        for j=1:size(I,2)
            for i=size(I,1):-1:1
                if i==size(I,1)
                    if vanish(i,j)==1
                        count(1,j)=count(1,j)+1;
                    end
                else
                    if clm_index(j,i+1)==1
                        if use(i,clm_index(j,i+1)+1)<=use(i,clm_index(j,i+1))
                            clm_index(j,i)=clm_index(j,i+1)+1;
                        else
                            clm_index(j,i)=clm_index(j,i+1);
                        end
                    elseif clm_index(j,i+1)==size(I,2)
                        if use(i,clm_index(j,i+1))<=use(i,clm_index(j,i+1)-1)
                            clm_index(j,i)=clm_index(j,i+1);                
                        else
                            clm_index(j,i)=clm_index(j,i+1)-1;
                        end
                    else
                        if use(i,clm_index(j,i+1))<=use(i,clm_index(j,i+1)-1)
                            if use(i,clm_index(j,i+1)+1)<=use(i,clm_index(j,i+1))
                                clm_index(j,i)=clm_index(j,i+1)+1;
                            else
                                clm_index(j,i)=clm_index(j,i+1);
                            end
                        else
                            if use(i,clm_index(j,i+1)-1)<=use(i,clm_index(j,i+1)+1)
                                clm_index(j,i)=clm_index(j,i+1)-1;
                            else
                                clm_index(j,i)=clm_index(j,i+1)+1;
                            end
                        end
                    end
                    if vanish(i,clm_index(j,i))==1
                        count(1,j)=count(1,j)+1;
                    end
                end
            end
        end