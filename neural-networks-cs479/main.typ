#import "@preview/summy:0.1.0": *

#set text(font: "Helvetica")

#show: cheatsheet.with(
  title: "Cheatsheet Title", 
  authors: "Authors",
  write-title: false,
  font-size: 5pt,
  line-skip: 5pt,
  x-margin: 20pt,
  y-margin: 20pt,
  num-columns: 5,
  column-gutter: 2.5pt,
  numbered-units: false,
)

#include "units/00-general-formula.typ"
#include "units/01-neurons.typ"
#include "units/02-synapses.typ"
#include "units/03-neural-learning.typ"
#include "units/04-universal-approximation-theorem.typ"
#include "units/05-loss-functions.typ"
#include "units/06-gradient-descent-learning.typ"
#include "units/07-error-backpropagation.typ"
#include "units/08-auto-differentiation.typ"
#include "units/09-neural-nets-with-auto-diff.typ"
#include "units/10-overfitting.typ"
#include "units/11-enhancing-optimization.typ"
#include "units/12-deep-neural-networks.typ"
#include "units/14-convolutional-neural-networks.typ"
#include "units/16-batch-normalization.typ"
#include "units/17-hopfield-networks.typ"
#include "units/18-recurrent-neural-networks.typ"
#include "units/19-gated-recurrent-units.typ"
#include "units/20-autoencoders.typ"
#include "units/21-vector-embeddings.typ"
#include "units/22-variational-autoencoder.typ"
#include "units/23-diffusion-models.typ"
#include "units/24-restricted-boltzmann-machines.typ"
#include "units/25-adversarial-attacks.typ"
#include "units/26-adversarial-defense.typ"
#include "units/27-population-coding.typ"
#include "units/28-transformations.typ"
#include "units/29-dynamics.typ"
#include "units/30-biological-backprop.typ"
#include "units/31-generative-adversarial-networks.typ"
#include "units/32-transformers.typ"