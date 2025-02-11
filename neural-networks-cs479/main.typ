#import "@preview/summy:0.1.0": *

#set text(font: "Helvetica")

#show: cheatsheet.with(
  title: "Cheatsheet Title", 
  authors: "Authors",
  write-title: false,
  font-size: 5.5pt,
  line-skip: 5.5pt,
  x-margin: 30pt,
  y-margin: 30pt,
  num-columns: 5,
  column-gutter: 4pt,
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