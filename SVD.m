%% MATLAB has a build in SVD command "svd"

% define number of rows and columns of matrix A
m = 10; 
n = 10;

% create random matrix of size m x n 
A1 = rand(m,n)

% find SVD decomposition of A
[U,Sigma,V] = svd(A1)
%% Find low-rank approximation of A using SVD
% create random matrix of size m x n and find its SVD
m = 5;
n = 3;
A = rand(m,n)
[U_k,Sigma,V_k] = svd(A);

% decide how many singular values to keep ( <n)
% change this value to see how the error differs
ksigma = 3;

% find the best rank k approximation of A by using a linear combination of
% outerproducts with the singular value of A as the weights
A_best = zeros(size(A));
for i = 1:ksigma
    A_best = A_best + (Sigma(i) * U_k(:,i) * V_k(:,i)');
end

A_best

% find the error of the best rank k approximation of A
err_A_best = norm((A-A_best),"fro")

%% Find the pseudo-inverse of A
% create random matrix A
m = 5;
n = 4;
A = rand(m,n);

% built in pesudeo-inverse command "pinv", works for any case
pinvA = pinv(A)

% to compute manually, need to divide into cases
% rank deficient case
A_rd = [-1 1 0; -1 0 1; 0 -1 1];
[m,n] = size(A_rd)
[U,S,V] = svd(A_rd)
U1 = U(:,1:n)
S1 = S(1:n,:)
invS1 = zeros(size(S1))
for i = 1:n
    if S1(i,i) ~= 0
        invS1(i,i) = 1/S1(i,i)
    else 
        invS1(i,i) = 0
    end
end
pinvA = V*invS1*U1'
pinvA1 = pinv(A_rd)



