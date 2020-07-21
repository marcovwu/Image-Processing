clear 
clc

I = imread('mountain.jpg');
I = imresize(I,0.25);
%I = imread('shoes.jpg');
%I = imread('penguins.jpg');
%I = imread('Couple.jpg');

% figure
% imshowpair(Gmag, Gdir, 'montage');
% title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')
% doc imgradient
% imagesc(Gmag)

slect = input("ori_remove = 0 , remove = 1 , reserve = 2 , pluse = 3 , punish_ori_remove = 4 , punish_remove = 5  :");
if slect==0
    run = seam_carving( I );
elseif slect==1
    run = seam_carving_remove( I );
elseif slect==2
    run = seam_carving_reserve( I );
elseif slect==3
    run = seam_carving_pluse( I );
elseif slect==4
    run = seam_carving_punish_ori_remove( I );
elseif slect==5
    run = seam_carving_punish_remove( I );
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
