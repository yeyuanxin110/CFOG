
clear;


% optical and sar matching
%im_Ref = imread('.\data\optical_ref.png');
%im_Sen = imread('.\data\SAR_sen.png');
%CP_initial_file = '.\data\OpticaltoSAR_initialCP.txt';


%lidar depth and optical matching
%   im_Ref = imread('.\data\LidarDepth_ref.png');
%   im_Sen = imread('.\data\optical1_sen.png');
%   CP_initial_file = '.\data\LidartoOptical_initialCP.txt';
 

% % %visible and infrared image matching
%  im_Ref = imread('.\data\visible_ref.tif');
%  im_Sen = imread('.\data\infrared_sen.tif');
%  CP_initial_file = '.\data\VisibletoInfrared_initialCP.txt';

% % %visible and SAR image matching
  im_Ref = imread('.\data\Stest3_ref.tif');
  im_Sen = imread('.\data\Stest3_sen.tif');
  CP_initial_file = '.\data\Stest3gcp.pts';


%im_Ref = imread('s2test.tif');
%im_Sen = imread('s1test.tif');
%CP_initial_file = 'gcp.pts';




% image matching using the proposed framework.
tic
[CP_Ref,CP_Sen] = CFOG_match(im_Ref,im_Sen,CP_initial_file);
fprintf('the total matching time is %fs\n',toc);

%error theshold
errThe =1.5;

%detect the error
[corrRefPt,corrSenPt] = ErrorDect(CP_Ref,CP_Sen,0,errThe);

%wirite the point in the envi format
corrPT = [corrRefPt,corrSenPt];%correct match

%[H1, inlier_ransac] = ransacfithomography(CP_Ref', CP_Sen', 0.001);

%cleanedPoints11 = matchedPoints1(inliersIndex, :);
%cleanedPoints22 = matchedPoints2(inliersIndex, :);
%corrRefPt1 = CP_Ref(inlier_ransac, :);
%corrSenPt1 =  CP_Ref(inlier_ransac, :);


path = 'D:\test1.pts'
Wenvifile1(corrPT',path);

figure;
imshow(im_Ref),hold on;
plot(corrRefPt(:,1),corrRefPt(:,2),'yo','MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',5);hold on;
title('reference image');

figure;
imshow(im_Sen),hold on;
plot(corrSenPt(:,1),corrSenPt(:,2),'yo','MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',5);hold on;
title('sensed image');
