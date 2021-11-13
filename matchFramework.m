function [CP_Ref,CP_Sen] = matchFramework(im_Ref,im_Sen,CP_initial_file,descriptor,disthre,tranFlag, templateSize, searchRad);

% detect the tie points using HOPC  (histogram of oriented phase
% congruency) by the template matching strategy.As the matlab cannot handle
% the georeference information of images, we use some initial control points by manually ('CP_initial_file')
% to determine the search region

% If you use this implementation please cite:
%

% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is here
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------

%
% Contact: yeyuanxin110@163.com
%input Parameters: 
%                 im_Ref: the reference image
%                 im_Sen: the sensed image
%                 CP_initial_file: the file path of the initial points. they are used to determine the searchRegion;                
%                 desriptor: the pixel-wise represatation, which can only be 'CFOG','FHOG','FLSS', or 'FSURF'
%                 disthre: the threshold of the errors of matching point pair, if the error of the point pair is less than dis, they are regrad as the correct match                 
%                 tranFlag:  the geometric transformation between two images for prediect the searth region. 0:affine, 1: projective, 2: Quadratic polynomial,3: cubic polynomial,the default is 3
%                 templateSize: the template size, its minimum value must be more than 20, the default is 100
%                 searchRad: the radius of searchRegion, the default is 10.

%                 
%                 
%                 
%                
%                
%                 

%return vaules:                
%                 CP_Ref: the coordinates ([x,y]) in the reference image
%                 CP_Sen: the coordinates ([x,y]) in the sensed image


if nargin < 3
    disp('the number input parameters must be >= 3 ');
    return;
end
if nargin < 4
    descriptor = 'CFOG';    % the descriptor for calculate the pixel-wise feature representation
end
if nargin < 5
    disthre = 1.5;        % the threshod of match errors
end
if nargin < 6
    tranFlag = 0;            % the type of geometric transformation between images
end
if nargin < 7
    templateSize = 40;% the template size
end
if nargin < 8
    searchRad = 20;    % the radius of search region
end


% tranfer the rgb to gray
[k1,k2,k3] = size(im_Ref);
if k3 == 3
    im_Ref = rgb2gray(im_Ref);
end
im_Ref = double(im_Ref);

[k1,k2,k3] = size(im_Sen);
if k3 == 3
    im_Sen = rgb2gray(im_Sen);
end
im_Sen = double(im_Sen);

[im_RefH,im_RefW] = size(im_Ref);
[im_SenH,im_SenW] = size(im_Sen);

templateRad = round(templateSize/2);    %the template radius
marg=templateRad+searchRad+2;           %the boundary. we don't detect tie points out of the boundary

matchRad = templateRad + searchRad; %the match radius,which is the sum of the template and search radius

 
CM = 0 ;%the number of total match 



%extract the interest points using blocked-harris
im1 = im_Ref(marg:im_RefH-marg,marg:im_RefW-marg);% remove the pixel near the boundary
Value = harrisValue(im1);                        % harris intensity value
[r,c,rsubp,cubp] = nonmaxsupptsgrid(Value,3,0.3,10,2); % non-maxima suppression in regular
                                                       % here is 5*5 grid
                                                       % 8 points in each grid, in total 200 interet points 

points1 =[r,c] + marg - 1;
pNum = size(points1,1); % the number of interest points


%caculate the pixel-wise feature represatation 
tic;
[feature_Ref,flag_Ref] = pixelFeature(im_Ref,descriptor);
[feature_Sen,flag_Sen] = pixelFeature(im_Sen,descriptor);

fprintf('the feature extraction time for two images is %f\n',toc);
%If the extracted feature is invaild
% if flag_Ref==0 || flag_Sen==0
%    fprinf('Invaild feature\n');
%    fprinf('the parameter des much be set to CFOG,FHOG,FLSS, or FSURF\n');
%    return;
% end

%read check points from file;
checkPt = textread(CP_initial_file);
refpt = [checkPt(:,1),checkPt(:,2)]; %the check points in the referencing image
senpt = [checkPt(:,3),checkPt(:,4)]; %the check points in the sensed image

% solve the geometric tranformation parameter
% tran 0:affine, 1: projective, 2: Quadratic polynomial,3: cubic polynomial,the default is 3
tform = [];
if tranFlag == 0
    tform = cp2tform(refpt,senpt,'affine'); 
    T = tform.tdata.T;
elseif tranFlag == 1
    tform = cp2tform(refpt,senpt,'projective');
    T = tform.tdata.T;
    else
    T = solvePoly(refpt,senpt,tranFlag);
end
H = T';%the geometric transformation parameters from im_Ref to im_Sen

%detect the tie points by the template matching strategy for each
%interestin pionts
for n = 1: pNum
    
    %the x and y coordinates in the reference image
    X_Ref=points1(n,2);
    Y_Ref=points1(n,1);
    
     
    
    %transform the (x,y) of reference image to sensed image by the geometric relationship of check points 
    %to determine the search region
    tempCo = [X_Ref,Y_Ref];
    tempCo1 = transferTo(tform,tempCo,H,tranFlag);
    
    %tranformed coordinate (X_Sen_c, Y_Sen_c)
    X_Sen_c = tempCo1(1);
    Y_Sen_c = tempCo1(2);
    X_Sen_c1=round(tempCo1(1));
    Y_Sen_c1 =round(tempCo1(2)); 

    %judge whether the transformed points are out the boundary of right image.

    if (X_Sen_c1 < marg+1 | X_Sen_c1 > size(im_Sen,2)-marg | Y_Sen_c1<marg+1 | Y_Sen_c1 > size(im_Sen,1)-marg)
        %if out the boundary, this produre enter the next cycle
        continue;
    end
        

     

            
     % get the pixel-wise representation of the match Region centered on (X_Ref,Y_Sen) and (X_Sen,Y_Sen)
     %featureSub_Ref = single(getFeatureSub(feature_Ref,Y_Ref,X_Ref,matchRad));
     %featureSub_Sen = single(getFeatureSub(feature_Sen,Y_Sen_c1,X_Sen_c1,matchRad));
     featureSub_Ref = feature_Ref(Y_Ref-matchRad:Y_Ref+matchRad,X_Ref-matchRad:X_Ref+matchRad,:);
     featureSub_Sen = feature_Sen(Y_Sen_c1-matchRad:Y_Sen_c1+matchRad,X_Sen_c1-matchRad:X_Sen_c1+matchRad,:);

         
           
     % FFT-based image matching
      [m1,n1,k1] = fftmatch(featureSub_Ref,featureSub_Sen,1);

       max_i = m1;
       max_j = n1;
     if (size(max_i,1) < 1 || size(max_j,1) < 1)
          continue;
      end
      
      %the (matchY,matchX) coordinates of match
      Y_match = Y_Sen_c1 + max_i(1);
      X_match = X_Sen_c1 + max_j(1);
      if (im_Sen(Y_match,X_match)<=0)
          continue;
      end
      
      CM=CM+1;
      CP_Ref(CM,:) = [X_Ref,Y_Ref];
      CP_Sen(CM,:) = [X_match(1),Y_match(1)];

end


