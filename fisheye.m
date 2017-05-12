im = imread('camera3.PNG');
if size(im,3)==3
    im1 = mean(im,3);
    im=im1;
end
im = im-min(min(im))+1;
im = uint8(im./max(max(im))*255);
figure
imshow(im)
%the two 10s in the line below are important...basically a measure of how
%focal length in millimeters multiplied by how many pixels per millimeter
%the -0.0005 is determined experimentally. all i know is that it should be
%negative and very small
params = cameraParameters('RadialDistortion',[-0.0005,0],'EstimateSkew',true,'EstimateTangentialDistortion',true,'IntrinsicMatrix',[10,0,0;0,10,0;size(im,1)/2,size(im,2)/2,1]);
[im,placeholder] = undistortImage(im,params);
figure
imshow(im)
