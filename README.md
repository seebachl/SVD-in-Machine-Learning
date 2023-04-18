# SVD-in-Machine-Learning

Supplementary code for "The Implementation of Singular Value Decomposition in Machine Learning". Each file can be downloaded and edited for the reader's enrichment to test different cases of the algorithms. A brief overview of how each file can be optimally edited to improve the reader's understanding is provided here. 

#### SVD_and_PCA.m
The goal of this file is to demonstrate how to find the singular value decomposition of a matrix as well how to perform principle component analysis using MATLAB. Try changing the spectrum on line 18 (for example, replace any number smaller than one with a number greater than 100) and observe the change in the resulting error plot when k is held constant. Alternatively, change k and observe how the value of the relative error of the best k-rank approximation of A, err_A_best, changes. In the pseudo-inverse cell, try changing A to a full-rank matrix and notice how A\b produces the same solution as the pseudo inverse. 
For the PCA cell, the [Statistics and Machine Learning Toolbox](https://www.mathworks.com/help/stats/index.html?s_tid=CRUX_lftnav) is required. In the PCA cell, observe how V, coeff, and Vs are all equal, offering three ways to find the feature vector of PCA. 

#### LSA.m 
The goal of this file is to demonstrate how latent semantic analysis uses SVD, finds documents based on queries, and folds-in new documents. It is based on titles of first-, second-, and third-year mathematics textbooks at McMaster University. Try changing ksigma on line 57 and see how the documents retrieved differ. In addition, try changing the query vector to imitate a search term, but be sure the search terms are present in the existing terms. 

#### For the next two files, the [Image Processing Toolbox](https://www.mathworks.com/help/images/index.html?s_tid=CRUX_lftnav) is required.

#### Image_Compression.m
The goal of this file is to demonstrate how image compression uses SVD for both grayscale and colour images. For both types of images, try changes the ksigma on lines 61 and 149 to find different compression ratios of images. With the plots of the singular values, you may be able to see where the image should look almost exactly the same as the original. Also, look at different images by changing image_title to a different file name from the folders Grayscale-Images and Colour-Images Ensure all files from these folders are downloaded to your device and exist in the same folder as the MATLAB file, otherwise the code may not run! Note a log x-axis is used for the plot of singular values in the colour image example to exaggerate the differences between the red, green, and blue layers. 

#### Facial_Recognition.m
The goal of this file is to demonstrate how facial recognition employs PCA. Ensure you have downloaded all the images from the folders Celebrity-Images and Test-Images and that they exist in the same folder as the MATLAB file before using this file. This file also shows how to recreate an image using varying number of eigenfaces. Change ksigma on line 55 to see how increasing the number of eigenfaces used creates a more clear image of the person of interest. To use the algorithm to identify faces in the Test-Images folder, change the file name on line 61 a different file from the folder. The code will output the name of the face closest to this face in the face space. 
