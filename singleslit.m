%various experimental parameters
sampled = 0.0181; %distance to sample
samplep = 380; %distance in pixels
xctr = 2510; %centre of strip
d = 1.2098; %real distance
lambda = 632.8*10.^-9; %laser wavelength
width = 2*0.013837*2.54/10/100; %slit width
xrange = [-0.04:0.0001:0.04]; %x values
zeropos = find(xrange==0); %location of centre
theta = atan (xrange./d); %angle of diffraction
var = width.*pi./lambda.*sin(theta); %intermediate variable
ip = (sin(var)./var).^2; %intensity
ip(zeropos) = 1; %define intensity at centre
%rgb intensity in image
rsens = 0.09;
gsens = 0.02;
bsens = 0.01;
shift = 180;
filt = 50;
mindist = 3;

%read in and process image
image = imread('test2.jpg');
values = image(:,:,1).*rsens+image(:,:,2).*gsens+image(:,:,3).*bsens; %determine overall intensity
newy = sum(values,1);
xsize = size(image,2);
newy = filter(ones(filt,1)./filt,1,newy);
%find peaks and troughs in intensity profile
[pks1,locs1] = findpeaks(newy);
[pks2,locs2] = findpeaks(-newy);
pks2 = -pks2;
locs2copy = locs2;
pks2copy = pks2;
for i=1:numel(locs2copy)
    if min(abs(locs1-locs2copy(i)))<mindist
        locs2(i)=-1;
        pks2(i)=-1;
    end
end
locs2(locs2==-1)=[];
pks2(pks2==-1)=[];
%smooth plot and do some processing
baseline = interp1(locs2,pks2,1:xsize);
newy = newy-baseline;
newy = newy./double(max(newy));
newy = newy.^2;
newx = [(-xctr./samplep.*sampled):(1./samplep.*sampled):((xsize-xctr-1)./samplep.*sampled)];
format long g
format compact

%display intensity profile
for i=1:10:numel(newy)
    disp(newy(i))
end
