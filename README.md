# Color-blob-based-COSFIRE
Color-blob-based COSFIRE filters for object recognition by Baris Gecer, George Azzopardi, Nicolai Petkov
This is the code required to run the Color-blob-based COSFIRE filters, the codes are described casually here and more formally in this paper:

[B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based COSFIRE filters for Object Recognition” Image and Vision Computing, vol. 57, pp. 165-174, 2017.](http://www.cs.rug.nl/~george/wp-content/uploads/2016/11/IMAVIS2017.pdf)

If you find this paper or code useful, we encourage you to cite the paper. BibTeX:

> @article{gecer2016color,
  title={Color-blob-based COSFIRE filters for object recognition},
  author={Gecer, Baris and Azzopardi, George and Petkov, Nicolai},
  journal={Image and Vision Computing},
  year={2016},
  publisher={Elsevier}
}

=============================================================================

Below we have short explanations of the scripts:

/demos

	Contain two simple examples to show how can you use the code
		- Toy example of faces
		- Marylin image

/CCOSFIRE

	Contains the core functions of our approach
	
 /ts
 
	Contains the codes for the experiments on the GTSRB data set (traffic signs)
	/wrapper
		The actual codes
		- to do a small experiment run Application.m
	/compile
		Files needed to run the code on cluster
	/exps
		Experiment results (i.e. see overall.txt or confusionMatrix)
		
/bf

	Contains the codes for the experiments on the butterfly data set
	/wrapper
		The actual codes
		- to do a small experiment run Application.m
	/compile
		Files needed to run the code on cluster
	/exps
		Experiment results (i.e. see overall.txt or confusionMatrix)
		
/org

	Contains the codes and experiments of the original COSFIRE paper:
	G. Azzopardi and N. Petkov, “Trainable COSFIRE filters for keypoint detection and pattern recognition”, IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 35 (2), pp. 490-503, 2013.

/libsvm-3.17

	contains libsvm codes directly adapted from: https://www.csie.ntu.edu.tw/~cjlin/libsvm/
	Please cite their work if you use it: https://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f203


