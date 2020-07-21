# -*- coding: utf-8 -*-
"""
Created on Thu Jun  4 21:39:38 2020

@author: Marco
"""

from __future__ import print_function
 
import torch
import scipy.io as sio
model_name = './models/e_AE_F.pkl'
model = torch.load(model_name)
print(model)
parameter = dict()
parameter['layer1.conv1_w'] = model.layer1[0].weight.data.cpu().numpy()
parameter['layer1.conv1_b'] = model.layer1[0].bias.data.cpu().numpy()
parameter['layer1.bn1_w'] = model.layer1[2].weight.data.cpu().numpy()
parameter['layer1.bn1_b'] = model.layer1[2].bias.data.cpu().numpy()
parameter['layer1.bn1_rm'] = model.layer1[2].running_mean.data.cpu().numpy()
parameter['layer1.bn1_rv'] = model.layer1[2].running_var.data.cpu().numpy()

parameter['layer1.conv2_w'] = model.layer1[3].weight.data.cpu().numpy()
parameter['layer1.conv2_b'] = model.layer1[3].bias.data.cpu().numpy()
parameter['layer1.bn2_w'] = model.layer1[5].weight.data.cpu().numpy()
parameter['layer1.bn2_b'] = model.layer1[5].bias.data.cpu().numpy()
parameter['layer1.bn2_rm'] = model.layer1[5].running_mean.data.cpu().numpy()
parameter['layer1.bn2_rv'] = model.layer1[5].running_var.data.cpu().numpy()

parameter['layer1.conv3_w'] = model.layer1[6].weight.data.cpu().numpy()
parameter['layer1.conv3_b'] = model.layer1[6].bias.data.cpu().numpy()
parameter['layer1.bn3_w'] = model.layer1[8].weight.data.cpu().numpy()
parameter['layer1.bn3_b'] = model.layer1[8].bias.data.cpu().numpy()
parameter['layer1.bn3_rm'] = model.layer1[8].running_mean.data.cpu().numpy()
parameter['layer1.bn3_rv'] = model.layer1[8].running_var.data.cpu().numpy()


parameter['layer2.conv1_w'] = model.layer2[0].weight.data.cpu().numpy()
parameter['layer2.conv1_b'] = model.layer2[0].bias.data.cpu().numpy()
parameter['layer2.bn1_w'] = model.layer2[2].weight.data.cpu().numpy()
parameter['layer2.bn1_b'] = model.layer2[2].bias.data.cpu().numpy()
parameter['layer2.bn1_rm'] = model.layer2[2].running_mean.data.cpu().numpy()
parameter['layer2.bn1_rv'] = model.layer2[2].running_var.data.cpu().numpy()

parameter['layer2.conv2_w'] = model.layer2[4].weight.data.cpu().numpy()
parameter['layer2.conv2_b'] = model.layer2[4].bias.data.cpu().numpy()

parameter['fc1'] = model.fc1.data.cpu().numpy()

sio.savemat('./models/e_AE_F.mat', mdict=parameter)