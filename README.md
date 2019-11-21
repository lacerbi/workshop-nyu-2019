# Introduction to modeling and model fitting in cognitive and computational neuroscience (2019)

This repository contains materials for an introductory workshop to modeling and model fitting in cognitive and computational neuroscience, part of which I presented at the Center for Neural Science, NYU in September 2019. 

This tutorial focuses on model fitting via optimization (i.e., maximum-likelihood and maximum-a-posteriori estimation), and on the Bayesian Adaptive Direct Search (BADS) optimization algorithm (https://github.com/lacerbi/bads).

I gave different versions of this tutorial at many other institutions and summer schools (see [here](http://luigiacerbi.com/tutorials/)).


## Tutorial


The main file for the tutorial is the script [ModelingTutorial.m](https://github.com/lacerbi/model-fitting-workshop/blob/master/ModelingTutorial.m). Slides are available [here](https://github.com/lacerbi/workshop-nyu-2019/blob/master/presentation/acerbi-nyu-tutorial-sep2019.pdf).

To run some of the model-fitting algorithms in the tutorial you need to download and install the following MATLAB toolboxes:
  - Bayesian Adaptive Direct Search (BADS): https://github.com/lacerbi/bads
  - Variational Bayesian Monte Carlo (VBMC): https://github.com/lacerbi/vbmc

For more info about my work in computational neuroscience and machine learning, follow me on Twitter: https://twitter.com/AcerbiLuigi

**Example: Optimization of Rosenbrock's function with BADS** ![Example: Optimization of Rosenbrock's function with BADS](https://github.com/lacerbi/workshop-bristol-2019/blob/master/docs/bads-optimviz.gif "Example: Optimization of Rosenbrock's function with BADS")

For more visualizations of optimization algorithms at work, see [here](https://github.com/lacerbi/optimviz).


## License

Code and scripts in this repository are released under the terms of the [MIT License](https://github.com/lacerbi/workshop-bristol-2019/blob/master/LICENSE).
