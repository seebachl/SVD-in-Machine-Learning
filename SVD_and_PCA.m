%% Finding the singular value decomposition (SVD) of a random m x n matrix
% using the building in MATLAB command 
clc
clear

% define number of rows and columns of matrix A
m = 10; 
n = 10;

% create random matrix of size m x n 
A1 = rand(m,n)

% find SVD decomposition of A
[U,Sigma,V] = svd(A1)

%% Finding a low-rank approximation of A using its SVD with a define spectrum
% create random matrix of size 30 x 30 with a given spectrum and find its SVD
evals = [100000 70000 9000 2000 1500 900 700 300 200 121 25 10 5 2 1 0.945 ...
    0.9 0.877 0.843 0.8 0.75 0.7 0.4 0.3 0.004 0.0032 0.002 0.0002 0.0001 ...
    0.0001]; % define the spectrum

Adiag = diag(evals,0); % create a diagonal matrix with eigenvalue entries
T = rand(30); % create a random 30 x 30 matrix
A = T * Adiag * inv(T); % perform a similarity transformation to maintain the spectrum
[U_k,Sigma,V_k] = svd(A); % find SVD 

% plot the singular values
fig1 = figure; clf;
plot(diag(Sigma),'bo-')
xlabel('Singular Value Position')
ylabel('Singular Value')

% decide how many singular values to keep, ksigma<30
% change this value to see how the error differs
ksigma = 1;

% find the best rank k approximation of A by using a linear combination of
% outerproducts with the singular value of A as the weights
A_best = zeros(size(A));
for i = 1:ksigma
    A_best = A_best + (Sigma(i,i) * U_k(:,i) * V_k(:,i)');
end

A_best;

% find the error of the best rank k approximation of A
err = norm(A-A_best);
err_A_best = norm(err)/norm(A)

% plot error as a function of the rank k approximation of A 
A_best = zeros(size(A));
err_list = zeros(30,1);
for k = 1:30
    A_best = zeros(size(A));
    for i = 1:k
        A_best = A_best + (Sigma(i,i) * U_k(:,i) * V_k(:,i)');
    end
    err_list(i) = norm(A-A_best)/norm(A);
end

% create figure of relative error as a function of the number of singular
% values used
fig2 = figure; clf;
plot(err_list,'bo-')
xlabel('Number of Singular Values Used') 
ylabel('Relative Error of Resulting Approximation Matrix') 

%% Find the pseudo-inverse of A using built-in MATLAB command
% define A as a rank-deficient matrix
A = [-1 1 0; -1 0 1; 0 -1 1]
b = [900; -601; 10]

A\b % note this gives no solution if A is non-singular

% built in pesudeo-inverse command "pinv", works for any case
pinvA = pinv(A)
pinvA*b %solves issue with least squares solution

%% Finding the principal components of a matrix using SVD, the built-in MATLAB command, and the standard PCA technique
% create random m x n matrix
m=5;
n=4;
A = rand(m,n)

% column-center the matrix
colcentered_A = zeros(size(A));
for i = 1:m
    for j = 1:n
        colcentered_A(i,j) = A(i,j)-mean(A(:,j));
    end
end

% find the V matrix of SVD as the principal components of A
[~,~,V] =svd(colcentered_A)

% PCA of matrix A using MATLAB command
coeff = pca(A) % note that V = coeff matrix (vectors may differ by a factor of -1)

% PCA by hand 
% standardize matrix
standardize_A = zeros(size(A));
for i = 1:m
    for j = 1:n
        standardize_A(i,j) = (A(i,j)-mean(A(:,j)))/std(A(:,j)); % here we choose to standardize the columns
    end
end
covariance = cov(A); % find the covariance matrix 
[V1,D1] = eig(covariance); % find the eigenvalues and eigenvectors 
[d, ind] = sort(diag(D1), 'descend'); % sort the eigenvalues and eigenvectors
Ds = D1(ind,ind);
Vs = V1(:,ind) % note Vs = V = coeff (may differ by factor of -1)

% choose how many principal components to keep
k = 2;
feat_vec = coeff(:,1:k)
project = standardize_A*feat_vec % project the centered matrix onto the feature vector
