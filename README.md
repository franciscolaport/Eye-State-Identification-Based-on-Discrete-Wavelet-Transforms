Code for the paper: Eye state identification based on discrete wavelet transforms [1].

Main document: Main.m
Performs the classification of both eye states using LDA and Wavelets.

Different wavelets can be configured/compared as well as different window sizes.

ldaClassifyByMinutes.m performs feature extraction (by calling extractNewFetarues.m) and classification.

The results are plotted by plotAccuracyPerWindowSize.m

The related data can be found at: https://zenodo.org/records/10168535 . readFiles.m es the responsible function to read this data. 

[1] Laport, F., Castro, P. M., Dapena, A., Vazquez-Araujo, F. J., & Fresnedo, O. (2021). Eye state identification based on discrete wavelet transforms. Applied Sciences, 11(11), 5051. DOI: https://doi.org/10.3390/app11115051
