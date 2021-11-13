function [feature,flag] = pixelFeature(im,descriptor);
%caculate the pixel-wise feature represatation using
%'CFOG','FHOG','FLSS','FSURF'.



% Contact: yeyuanxin110@163.com
%input Parameters: 
%                 im: the input image
%                 descriptor: the pixel-wise represatation, which can only be 'CFOG','FHOG','FLSS', or 'FSURF'


%return vaules:                
%                 feature: pixel-wise feature represatation
%                 flag: 1 denote success of feature represatation, 0
%                 denotes fail of feature represatation



% get the first band of the image for feature extraction;

flag = 1;
switch(descriptor)
    case 'CFOG'
        % caculate the CFOG
        feature = CFOG(im,9,0.8,0);

    case 'FHOG'
        %calculate the gradient magnitude and orientation
        [grad,or,or_1] = imgrad2(im,0);
        or_1(or_1<0) = or_1(or_1<0)+pi;
        
        %caluate the pixel-wise hog descriptor
        feature = FHOG(single(grad),single(or_1));
    case 'FLSS'        
        % calculate the pixel-wise LSS descriptor       
        feature = FLSS(im);
    case 'FSURF'
        % calculate the pixel-wise LSS descriptor
        feature = FSURF(im);
    otherwise
        flag = 0;
end
       
    
    