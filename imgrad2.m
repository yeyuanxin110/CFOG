function [g,or,or1] = imgrad2(im,sigma)
if sigma ~=0
    im_s = gaussfilt(im,  sigma);
else
    im_s = im;
end
[gx,gy] = gradient(double(im_s));
g = sqrt(gx.*gx + gy.*gy);
or = atan2(-gy,gx);
or1 = atan(gy./(gx+0.00000001));
end