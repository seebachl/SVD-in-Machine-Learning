%% An example of a simple facial recognition algorithm using PCA and eigenfaces 
% Compress multiple images in a database into one matrix
% ensure all documents from Celebrity-Images and Test-Images are downloaded
% on your device
clc
clear

F = zeros(100*100, 17);
for k = 1:17
  Filename = strcat('face', num2str(k), '.jpg');
  imageData = imread(Filename);
  grayscale = rgb2gray(imageData);
  F(:,k) = grayscale(:);
end

% Finding the average Face
mu = mean(F,2);
F = F - repmat(mu, 1, 17);
imshow(mat2gray(reshape(mu, [100, 100]))) %this is the average face
title("Average Face")

%% Finding the eigenfaces of the matrix F using the method described in the paper
% computing the true covariance matrix takes a very long time 

C = F'*F; 
[evec, eval] = eig(C); %find the eigenvectors and values of F'F
U = zeros(100*100, 100*100);
for i = 1:size(evec,2)
    u = F*evec(:,i)/(norm(F*evec(:,i))); %multiply by F and normalize to find orthonormal basis for range of F (face space)
    U(:,i) = u;
end
[eval, ind] = sort(diag(eval), 'descend'); % order eigenfaces based on corresponding eigenvalues
U = U(:,ind);

% Plot and show the first 8 eigenfaces
for i = 1:8 
    img = reshape(U(:,i), [100,100]);
    subplot(2,4,i);
    imshow(mat2gray(img))
    title(sprintf("Eigenface %i", i))
end
%% Example of reconstructing one face in lower dimension
% Code adapted from Machine Learning : A Bayesian and Optimization Perspective by Sergios Theodoridis
% Chose which image to recreate (change second index to choose a different face) 
X = F(:,2);

% Project image onto face space (find weight vector)
Y = U'*X;

% Resort faces based on weight vector Y 
[~,indx] = sort(abs(Y), 'descend');

% Recreate face using different amount of eigenfaces (change sigma)
% increasing ksigma will improve the image
ksigma = 5
R = U(:,indx(1:ksigma))*Y(indx(1:ksigma))+mu; 
imshow(mat2gray(reshape(R, 100, 100)))

%% Facial recognition -- using an image from the Test-Images file, this code identifies the face based on the Celebrity-Images data set
% Read the image turn it into a vector
imageData = imread('identifyjolie.jpg');
grayscale = rgb2gray(imageData);
unknown = grayscale(:);
imshow(mat2gray(grayscale))

% Find face space projection of known images 
% (Similar to Omega_l but there is only one face for each class)
x = U'*F;

% Project the image onto the face space
omega = U'*(double(unknown) - mu); %finding weights of new image

% find the Euclidean distance from each weight vector
eps = zeros(17,1);
for i = 1:17
    eps(i) = norm(x(:,i)-omega);
end

% find the smallest Euclidean distance
% we use minimum instead of threshold since we know the face belongs to
% someone in our set
% the corresponding image (face(i).jpg) is who the system is the image recognizing as
[~, i] = (min(eps));
data = [[1:17]; ["Angelina Jolie", "Brad Pitt", "Denzel Washington", "Hugh Jackman", "Jennifer Lawrence", "Johnny Depp", "Kate Winslet", "Leonardo DiCaprio", "Megan Fox", "Natalie Portman", "Nicole Kidman", "Robert Downey Jr.", "Sandra Bullock", "Scarlett Johansson", "Tom Cruise", "Tom Hanks", "Will Smith"]];
sprintf("This is %s", data(2,i))


