%% How image compression can be used for black and white images
% import and display image
% window from Merisha Singh Suwal via Kaggle (highest quality) 
% rest of images from Set12 Zhang et al., 2016
clear
clc
image_title = 'woman'; %change the title to select a different image 

if strcmp(image_title,'window')
    img = imread('window.png');
elseif strcmp(image_title,'airplane')
    img = imread('airplane.png');
elseif strcmp(image_title,'boat')
    img = imread('boat.png');
elseif strcmp(image_title,'butterfly')
    img = imread('butterfly.png');
elseif strcmp(image_title,'cameraman')
    img = imread('cameraman.png');
elseif strcmp(image_title,'couple')
    img = imread('couple.png');
elseif strcmp(image_title,'house')
    img = imread('house.png');
elseif strcmp(image_title,'man')
    img = imread('man.png');
elseif strcmp(image_title,'parrot')
    img = imread('parrot.png');
elseif strcmp(image_title,'peppers')
    img = imread('peppers.png');
elseif strcmp(image_title,'sitting woman')
    img = imread('sittingwoman.png');
elseif strcmp(image_title,'starfish')
    img = imread('starfish.png');
elseif strcmp(image_title,'woman')
    img = imread('woman.png');
end
% figure(1)
imshow(img)
[m, n] = size(img);
t=(sprintf('Original %s Image', image_title)); title(t)
set(gca,'fontsize',18)
set(gcf,'position',0.9*get(0,'ScreenSize'))
sprintf('image has size %i x %i = %i entries\n',size(img,1),size(img,2),numel(img))

%% Find SVD decomposition of image and plot the singular values
[U,S,V] = svd(double(img));

% Arrange descending singular values
[sigma, idx] = sort(diag(S),'descend');
U = U(:,idx);
V = V(:,idx);
sprintf('Image has a total of %i singular values\n\n',numel(sigma))

% Plot singular values
figure(2);plot(sigma,'linewidth',3)
xlabel('Rank');ylabel('Singular Value');
title(sprintf('Singular Values of %s', image_title));
set(gca,'fontsize',18);axis([1 numel(sigma) 0 max(sigma)]); grid on;
set(gcf,'position',0.5*get(0,'ScreenSize'))

%% Plot compressed images with different numbers of singular values
ksigma = 30; %edit this number to see how the image appears with different truncations

img_best = zeros(size(img));
for i = 1:ksigma
    img_best = img_best + sigma(i) * U(:,i) * V(:,i)';
end

ndata = ksigma + ksigma * 2*size(U,1);
comp_ratio = m*n/(ksigma*(m+n+1))

t = sprintf(' approximation using largest %i singular values and %.1f percent of the original data\n', ksigma, 100*ndata/numel(img));
fprintf([image_title t]);

A_img = mat2gray(img_best); % needs image processing toolbox
figure;imshow(A_img);
t = sprintf([image_title sprintf(' image built from %i largest singular values',ksigma);] );
title(t);
set(gca,'fontsize',18)
set(gcf,'position',0.9*get(0,'ScreenSize'))
%% How image compression can be used for colour images
% load images
% images from Afifi et al. 2020
clear
image_title = 'waterlily'; %change the title to select a different image 

if strcmp(image_title,'beach')
    img = imread('beach.jpg');
elseif strcmp(image_title,'elephant')
    img = imread('elephant.jpg');
elseif strcmp(image_title,'hike')
    img = imread('hike.jpg');
elseif strcmp(image_title,'path')
    img = imread('path.jpg');
elseif strcmp(image_title,'rocks')
    img = imread('rocks.jpg');    
elseif strcmp(image_title,'sheep')
    img = imread('sheep.jpg');
elseif strcmp(image_title,'sunset')
    img = imread('sunset.jpg');
elseif strcmp(image_title,'villa')
    img = imread('villa.jpg');
elseif strcmp(image_title,'waterlily')
    img = imread('waterlily.jpg');
end
% figure(1)
imshow(img)
[m, n, p] = size(img);
t=(sprintf('Original %s Image', image_title)); title(t)
set(gca,'fontsize',18)
set(gcf,'position',0.9*get(0,'ScreenSize'))
sprintf('Image has size %i x %i x %i = %i entries\n',m,n,p,numel(img))

%% Extract and -erform SVD on each matrix
red = img(:,:,1); % Red matrix
green = img(:,:,2); % Green matrix
blue = img(:,:,3); % Blue matrix

[Ur, Sr, Vr] = svd(double(red));
[Ug, Sg, Vg] = svd(double(green));
[Ub, Sb, Vb] = svd(double(blue));

[sigmar, idxb] = sort(diag(Sr),'descend');
Ur = Ur(:,idxb);
Vr = Vr(:,idxb);
sprintf('Red layer has a total of %i singular values\n\n',numel(sigmar))

[sigmag, idxg] = sort(diag(Sg),'descend');
Ug = Ug(:,idxg);
Vg = Vg(:,idxg);
sprintf('Green layer has a total of %i singular values\n\n',numel(sigmag))

[sigmab, idxb] = sort(diag(Sb),'descend');
Ub = Ub(:,idxb);
Vb = Vb(:,idxb);
sprintf('Blue layer has a total of %i singular values\n\n',numel(sigmar))

% Plot singular values
x = [1:length(sigmar)]';
yr = sigmar;
yg = sigmag;
yb = sigmab;
figure(2);plot(log(x), yr, 'r', log(x), yg, 'g', log(x), yb, 'b')
xlabel('Log of Rank');ylabel('Singular Value');
title(sprintf('Singular Values of %s', image_title));
set(gca,'fontsize',18); 
grid on;
set(gcf,'position',0.5*get(0,'ScreenSize'))
%% Plot compressed images with different numbers of singular values
ksigma = 100; % edit this number to see how the image appears with different truncations

% find the approximations of each layer
red_best = zeros(m,n);
for i = 1:ksigma
    red_best = red_best + sigmar(i) * Ur(:,i) * Vr(:,i)';
end
green_best = zeros(m,n);
for i = 1:ksigma
    green_best = green_best + sigmag(i) * Ug(:,i) * Vg(:,i)';
end
blue_best = zeros(m,n);
for i = 1:ksigma
    blue_best = blue_best + sigmab(i) * Ub(:,i) * Vb(:,i)';
end

comp_ratio = m*n/(ksigma*(m+n+1))

t = sprintf(' approximation using largest %i singular values and a compression ratio of %.1f \n', ksigma, comp_ratio);
fprintf([image_title t]);

rgbImage(:,:,1) = uint8(red_best);
rgbImage(:,:,2) = uint8(green_best);
rgbImage(:,:,3) = uint8(blue_best);
figure;imshow(rgbImage);
t = sprintf([image_title sprintf(' image built from %i largest singular values',ksigma);] );
title(t);
set(gca,'fontsize',18)
set(gcf,'position',0.9*get(0,'ScreenSize'))
