function feature = CFOG(im,nOrient,sigma,flag)
%input Parameters: 
%            im: the input image
%            number: the number of nOrient bins,the default value is 9;
%            sigma: the sigma of Guassian, the default value is 0.8;                
%            flag: the C or matlab version of CFOG, 0: C version, 1: matlab
%                   version, the default is 0;      

%return vaules:                
%           feature: the output feature;

if nargin < 1
    disp('the number input parameters must be >= 1 ');
    return;
end
if nargin < 2
    nOrient = 9;    % the number of nOrient bins for calculating CFOG
end
if nargin < 3
    sigma = 0.8;        % the sigma value of Guassian for caculating CFOG
end 
if nargin < 4
    flag = 0;            % using C version code
end

im = single(im);
if ~flag 
    % the CFOG of C，using L2 normalise
    feature = CFOG_C(im,nOrient,sigma);
else
    % the CF0G of C++
     % L1 normalise for CFOG
    feature = CFOG_matlab1(im,nOrient,sigma);
    % L2 normalise for CFOG
    %feature = CFOG_matlab2(im,nOrient,sigma);
end
    