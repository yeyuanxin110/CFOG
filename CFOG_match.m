function [CP_Ref,CP_Sen] = CFOG_match(im_Ref,im_Sen,CP_initial_file,disthre,tranFlag, templateSize,searchRad);

% detect the tie points using CFOG 
% by the template matching strategy.As the matlab cannot handle
% the georeference information of images, we use some initial control points by manually ('CP_initial_file')
% to determine the search region

% If you use this implementation please cite:
% Y Ye, L Bruzzone, J Shan, F Bovolo, and Q Zhu. Fast and Robust Matching for Multimodal Remote Sensing Image Registration

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
%                 precision: the correct match ratio

if nargin < 3
    disp('the number input parameters must be >= 3 ');
    return;
end
if nargin < 4
    disthre = 1.5;        % the threshod of match errors,here we do not use that
end
if nargin < 5
    tranFlag = 0;            % the type of geometric transformation between images
end
if nargin < 6
    templateSize = 100;% the template size
end
if nargin < 7
    searchRad = 10;    % the radius of search region
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

 
C = 0;;%the number of correct match 
CM = 0 ;%the number of total match 
C_e = 0;%the number of mismatch



%extract the interest points using blocked-harris
im1 = im_Ref(marg:im_RefH-marg,marg:im_RefW-marg);% remove the pixel near the boundary
Value = harrisValue(im1);                        % harris intensity value
[r,c,rsubp,cubp] = nonmaxsupptsgrid(Value,3,0.3,20,1); % non-maxima suppression in regular
                                                       % here is 5*5 grid
                                                       % 8 points in each grid, in total 200 interet points 

points1 =[r,c] + marg - 1;
pNum = size(points1,1); % the number of interest points


%caculate the CFOG 
tic;

% using matlab code
 feature_Ref = CFOG_matlab(single(im_Ref));
  feature_Sen = CFOG_matlab(single(im_Sen));

% using c++ code
% feature_Ref = CFOG_C(single(im_Ref));
% feature_Sen = CFOG_C(single(im_Sen));



  
%feature_Ref = im_Ref;
%feature_Sen = im_Sen;
fprintf('the feature extraction time for two images is %fs\n',toc);


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
    val1 = im_Ref(Y_Ref-3:Y_Ref+3,X_Ref-3:X_Ref+3);
    val1_min = min(min(val1));
    if val1_min <= 0
        continue;
    end

    
     
    
    %transform the (x,y) of reference image to sensed image by the geometric relationship of check points 
    %to determine the search region
    tempCo = [X_Ref,Y_Ref];
    tempCo1 = transferTo(tform,tempCo,H,tranFlag);
    
    %tranformed coordinate (X_Sen_c, Y_Sen_c)
    X_Sen_c = tempCo1(1);
    Y_Sen_c = tempCo1(2);
    X_Sen_c1=round(tempCo1(1));
    Y_Sen_c1 =round(tempCo1(2))+00; 
    
   

    %judge whether the transformed points are out the boundary of right image.

%     if (X_Sen_c1 < marg+1 | X_Sen_c1 > size(im_Sen,2)-marg | Y_Sen_c1<marg+1 | Y_Sen_c1 > size(im_Sen,1)-marg)
%         %if out the boundary, this produre enter the next cycle
%         continue;
%     end
    
    if (X_Sen_c1 < marg+1 | X_Sen_c1 > size(im_Sen,2)-marg | Y_Sen_c1<marg+1 | Y_Sen_c1 > size(im_Sen,1)-marg)
        %if out the boundary, this produre enter the next cycle
        continue;
    end
        
    val1 = im_Sen((Y_Sen_c1-3):(Y_Sen_c1+3),(X_Sen_c1-3):(X_Sen_c1+3));
    val1_min = min(min(val1));
    if val1_min <= 0
        continue;
    end
     

            
     % get the CFOG feature of the match Region centered on (X_Ref,Y_Sen) and (X_Sen,Y_Sen)
     featureSub_Ref = single(feature_Ref(Y_Ref-matchRad:Y_Ref+matchRad,X_Ref-matchRad:X_Ref+matchRad,:));
     featureSub_Sen = single(feature_Sen(Y_Sen_c1-matchRad:Y_Sen_c1+matchRad,X_Sen_c1-matchRad:X_Sen_c1+matchRad,:));
     

         
           
     % FFT-based image matching
      [m1,n1,k1] = fftmatch(featureSub_Ref,featureSub_Sen,1);

       max_i = m1(1);
       max_j = n1(1);
   
      
      %the (matchY,matchX) coordinates of match
      Y_match = Y_Sen_c1 + max_i;
      X_match = X_Sen_c1 + max_j;
      C=C+1;
      corrp(C,:)=[X_Ref,Y_Ref,X_match,Y_match];% the coordinates of correct matches
    
      

end
      %the correct ratio

       CP_Ref = corrp(:,1:2);
       CP_Sen = corrp(:,3:4);
 
end


