function diff = diffractiongrating(T)

%various measured constants from the lab
ypt = 2505; %height of strip
xctr = 3300; %centre of strip
xb = 3665; %blue part of spectrum
xr = 4489; %red part of spectrum
sampled = 0.01; %aperture
samplep = 150; %scaling of image
diffconst = 1/600*10^-3; %empirical constant
d = 0.09; %distance
h = 6.626*10^-34; %planck's constant
c = 2.998*10^8; %speed of light
kb = 1.381*10^-23; %boltzmann constant

%approximation of camera response at various wavelengths 
lcoarse = [400:100:1000]*10^-9;
rcoarse = [0,0,0.005,0.015,0.07,0.098,0.02];
gcoarse = [0,0.001,0.029,0.067,0.043,0.015,0.006];
bcoarse = [0,0.013,0.025,0.013,0.008,0.015,0.006];

%read in image and process
image = imread('test4.jpg');
xdist = ([xb:xr]-xctr)*sampled/samplep; %width in pixels
lambda = diffconst.*xdist./sqrt(xdist.^2+d^2); %wavelength function
%smooth camera response from approximation
rfine = interp1(lcoarse,rcoarse,lambda);
gfine = interp1(lcoarse,gcoarse,lambda);
bfine = interp1(lcoarse,bcoarse,lambda);
roi = image(ypt,xb:xr,:); %region of interest on image
output = [];
%determine location on image for each wavelength
for i=1:numel(lambda)
    roi(1,i,:);
    [rfine(i),gfine(i),bfine(i)];
    output(i) = double(roi(1,i,1))*rfine(i)+double(roi(1,i,2))*gfine(i)+double(roi(1,i,3))*bfine(i);
end
format long g
format compact

%plot intensity of each wavelength
figure
plot(lambda,output+2.5)
hold on
Bl = 2*h*c^2./lambda.^5*1./(exp(h*c./(lambda.*kb*T))-1);
plot(lambda,Bl/2.5/10^10)
axis([4*10^-7,7*10^-7,0,18]);
%format plot
for i=1:10:numel(lambda)
    disp(Bl(i)/2.5/10^10)
end
%scaling plot
z = 648;
diff = sum(abs(output(1:z)-Bl(1:z)/2.5/10^10));

