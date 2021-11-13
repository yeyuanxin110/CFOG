
clear;
% add the path of feature extraction functions
addpath('.\pixel-wise feature represatation\CFOG');
addpath('.\pixel-wise feature represatation\FHOG');
addpath('.\pixel-wise feature represatation\FLSS');
addpath('.\pixel-wise feature represatation\FSURF');

% optical and sar matching
 im_Ref = imread('.\data\optical_ref.png');
 im_Sen = imread('.\data\SAR_sen.png');
 CP_initial_file = '.\data\OpticaltoSAR_initialCP.txt';


%lidar depth and optical matching
% im_Ref = imread('.\data\LidarDepth_ref.png');
% im_Sen = imread('.\data\optical1_sen.png');
% CP_initial_file = '.\data\LidartoOptical_initialCP.txt';

% % %visible and infrared image matching
% im_Ref = imread('.\data\visible_ref.tif');
% im_Sen = imread('.\data\infrared_sen.tif');
% CP_initial_file = '.\data\VisibletoInfrared_initialCP.txt'

%optical and lidar intensity matching 
% im_Ref = imread('.\other data\optical-LiDAR\LiDARintensity1_sen.tif');
% im_Sen = imread('.\other data\optical-LiDAR\visible1_ref.tif');
% CP_initial_file = '.\other data\optical-LiDAR\LiDARToVisible1.txt';

%map and optical matching 
im_Ref = imread('.\other data\optical-Map\optical1_ref.tif');
im_Sen = imread('.\other data\optical-Map\map1_sen.tif');
CP_initial_file = '.\other data\optical-Map\opticalToMap1_CP.txt';
 

%hongtu
% im_Ref = imread('.\data\Rredband1.tif');
% im_Sen = imread('.\data\¶à¹âÆ×Ó°Ïñ1_Resample.tif');
% CP_initial_file = '.\data\gcp.txt';

% image matching using the proposed framework.
tic
%using CFOG
%[CP_Ref,CP_Sen] = matchFramework(im_Ref,im_Sen,CP_initial_file,'CFOG');
%using FHOG
%[CP_Ref,CP_Sen] = matchFramework(im_Ref,im_Sen,CP_initial_file,'FHOG');
%using FLSS
[CP_Ref,CP_Sen] = matchFramework(im_Ref,im_Sen,CP_initial_file,'FLSS');
%using FSURF 
%[CP_Ref,CP_Sen] = matchFramework(im_Ref,im_Sen,CP_initial_file,'FSURF');

fprintf('the total matching time is %f\n',toc);

%detect the error
[corrRefPt,corrSenPt] = ErrorDect(CP_Ref,CP_Sen,0,1.5);
%wirite the point in the envi format
corrPT = [corrRefPt,corrSenPt];%correct match
path = 'D:\test1.pts'
Wenvifile1(corrPT',path);
%diplay the tie points 
figure;
imshow(im_Ref),hold on;
plot(corrRefPt(:,1),corrRefPt(:,2),'yo','MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',5);hold on;
title('reference image');

figure;
imshow(im_Sen),hold on;
plot(corrSenPt(:,1),corrSenPt(:,2),'yo','MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',5);hold on;
title('sensed image');