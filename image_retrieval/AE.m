%%
layers = [
    imageInputLayer([64 64 3])%�Ӥ��j�p&�Ƕ�&&�ЦU��P�ǧ�V�m�M���շӤ� resize ��100x100
 
   convolution2dLayer(3,16,'Padding',1)%
    reluLayer
    batchNormalizationLayer   
   convolution2dLayer(3,32,'Padding',1)%
    reluLayer
    batchNormalizationLayer   
   convolution2dLayer(3,64,'Padding',1)%
    reluLayer
    batchNormalizationLayer   
    maxPooling2dLayer(2,'Stride',2)

   convolution2dLayer(3,128,'Padding',1)
    reluLayer
    batchNormalizationLayer    
    maxPooling2dLayer(2,'Stride',2)
   convolution2dLayer(3,256,'Padding',1)
    reluLayer 
    fullyConnectedLayer(2000)];

options = trainingOptions('adam',...
            'MaxEpochs',1, ...
            'Plots','training-progress');
        
digitDatasetPath = fullfile('./collection_for_1052/collection_for_1052/');%�ЦU��P�ǧ��new3���e���|
digitData = imageDatastore(digitDatasetPath,'IncludeSubfolders',true,'LabelSource','foldernames');
[trainDigitData,valDigitData] = splitEachLabel(digitData,0.9);  

net = network;
net.layers = layers;
net = feedforwardnet;

net = trainNetwork(trainDigitData,layers,options);

a=predict(Layers,query_img);
%%
ori_img = imread('./collection_for_1052/collection_for_1052/1 (1).jpg');
query_img = imresize(ori_img,[64 64]);
answer = layers(1)(query_img);





