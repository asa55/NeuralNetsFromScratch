# I did this for class and never really considered sharing it with the world.

The project instructions were as follows (literally no additional resources - this was very open-ended):
_____________________________________________________________________________
## Neural Network for Handwritten Character Recognition

 

We will implement an Artificial Neural Network, which is trained using the back propagation algorithm, to recognize the handwritten characters.

 

## Data can be downloaded from:

http://www.ee.surrey.ac.uk/CVSSP/demos/chars74k/EnglishHnd.tgz

Please use the image data.

 

1. In this project, the result of ANN is a matrix of 1*62. The output being obtained from the ANN can be used to obtain one of the 62 (26 Upper-Case, 26 Lower-Case, 10 numbers) characters of the English language.

2. The neural network implemented in this project is composed of 3 layers, one input, one hidden and one output. The input layer has neurons which use the images as inputs, the hidden layer has 100 neurons, and the output layer has 62 neurons.

3. For this project, the sigmoid function is used as a non-linear neuron activation function. Bias terms (equal to 1) with trainable weights were also included in the network structure.

4. Each class has 55 samples.  In each class, please randomly select 5 samples as testing data and the rest 50 samples as training data.

5. Hand in a simple report to summarize your implementations and results.

6. Send everything together via Blackboard.

7. Please note that the students should write all codes by yourself, not use any code from online.
___________________________________________________________________________


## See the link in the `ReadMe.md` (in the parent folder of `algo/`) for a link to a detailed report and more. You can start your simulation where I left off if you download these materials. 

This code uses handwritten digits pulled from a popular MNIST database. I didn't copy the data to GitHub (that's poor form),
but you can find the link in the instructions (or grab a copy of them from my Dropbox).

If you decide to check out this code, you'll need Matlab (I developed on 2018a so I can't guarantee this is compatible with earlier versions)

Assuming you have 2018a or later already, you'll need to grab this code, pull it into a folder on your Matlab path, then add
the MNIST database images to a subdirectory of the `algo/` folder (e.g. `algo/EnglishHnd/English/Hnd/Img/...`)

As I mentioned, you can find extensive support for this code in my DropBox. Go up a folder level - there is a link in the main `ReadMe.md` file for this repo.
