import os
os.chdir("results_BlackScholes_NEW")
os.system("python power.py BlackScholes")
os.system("cp outBlackScholes.csv ../")
os.chdir("../results_FastWalshTransform_NEW")
os.system("python power.py FastWalsh")
os.system("cp outFastWalsh.csv ../")
os.chdir("../results_FloydWarshall_NEW")
os.system("python power.py Floyd")
os.system("cp outFloyd.csv ../")
os.chdir("../results_MatrixMultiplication_NEW")
os.system("python power.py Matrix")
os.system("cp outMatrix.csv ../")
os.chdir("../results_QuasiRandomSequence_NEW")
os.system("python power.py Quasi")
os.system("cp outQuasi.csv ../")
os.chdir("../results_SimpleConvolution_NEW")
os.system("python power.py SimpleConvolution")
os.system("cp outSimpleConvolution.csv ../")
os.chdir("../results_SobelFilter_NEW")
os.system("python power.py Sobel")
os.system("cp outSobel.csv ../")
