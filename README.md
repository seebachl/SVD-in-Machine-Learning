# SVD-in-Machine-Learning

Supplementary code for "The Implementation of Singular Value Decomposition in Machine Learning". Each file can be downloaded and edited for the reader's enrichment to test different cases of the algorithms. A brief overview of how each file can be optimally edited to improve the reader's understanding is provided here. 

#### SVD_and_PCA 
The goal of this file is to demonstrate how to find the singular value decomposition of a matrix as well how to perform principle component analysis using MATLAB. Try changing the spectrum on line 18 (for example, replace any number smaller than one with a number greater than 100) and observe the change in the resulting error plot when k is held constant. Alternatively, change k and observe how the value of the relative error of the best k rank approximation of A, err_A_best, changes. In the pseudo-inverse cell, try changing A to a full rank matrix and notice how A\b produces the same solution as the pseudo inverse. In the PCA cell, notice how V, coeff, and Vs are all equal, offering three ways to find the feature vector of PCA. 

