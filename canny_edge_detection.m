clear all;
close all;

Nx1=10;Sigmax1=2;Nx2=10;Sigmax2=2;Theta1=pi/2;
Ny1=10;Sigmay1=2;Ny2=10;Sigmay2=2;Theta2=0;
alfa=0.1;

% Read the image
[x, map] = imread('lena.gif');
w = ind2gray(x, map);
figure(1);
colormap(gray);
subplot(3,2,1);
imshow(w, []);
title('Image: lena.gif');

% Caculate the gradient on x
subplot(3,2,2);
filterx=d2dgauss(Nx1,Sigmax1,Nx2,Sigmax2,Theta1);
Ix= conv2(double(w),double(filterx),'same');
imshow(Ix, []);
title('Ix');

% Caculate the gradient on y
subplot(3,2,3);
filtery=d2dgauss(Ny1,Sigmay1,Ny2,Sigmay2,Theta2);
Iy=conv2(double(w),double(filtery),'same'); 
imshow(Iy, []);
title('Iy');

% Get norm of gradient
subplot(3,2,4);
NVI=sqrt(Ix.*Ix+Iy.*Iy);
imshow(NVI, []);
title('Norm of Gradient');

% Apply the threshold
I_max=max(max(NVI));
I_min=min(min(NVI));
level=alfa*(I_max-I_min)+I_min;
subplot(3,2,5);
Ibw=max(NVI,level.*ones(size(NVI)));
imshow(Ibw, []);
title('After Thresholding');

% Apply Non-Maximum suppression
% http://en.wikipedia.org/wiki/Canny_edge_detector#Non-maximum_Suppression
subplot(3,2,6);
[n,m]=size(Ibw);
for i=2:n-1,
for j=2:m-1,
    % Caculate if the pixel is larger than threshold
	if Ibw(i,j) > level,
	X=[-1,0,+1;-1,0,+1;-1,0,+1];
	Y=[-1,-1,-1;0,0,0;+1,+1,+1];
	Z=[Ibw(i-1,j-1),Ibw(i-1,j),Ibw(i-1,j+1);
	   Ibw(i,j-1),Ibw(i,j),Ibw(i,j+1);
	   Ibw(i+1,j-1),Ibw(i+1,j),Ibw(i+1,j+1)];
	XI=[Ix(i,j)/NVI(i,j), -Ix(i,j)/NVI(i,j)];
	YI=[Iy(i,j)/NVI(i,j), -Iy(i,j)/NVI(i,j)];
    
    % Use interpolation to caculate gradient value along the direction
	ZI=interp2(X,Y,Z,XI,YI);
		if Ibw(i,j) >= ZI(1) & Ibw(i,j) >= ZI(2)
		I_temp(i,j)=I_max;
		else
		I_temp(i,j)=0;
		end
	else
	I_temp(i,j)=0;
	end
end
end
imshow(I_temp, []);
title('After Non-Maximum suppression');