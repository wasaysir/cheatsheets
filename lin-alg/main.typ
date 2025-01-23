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
#include "units/01-vector-spaces.typ"
#include "units/02-linear-transformations.typ"
#include "units/03-diagonalizability.typ"
#include "units/04-inner-product-spaces.typ"
#include "units/05-orthogonal-diagonalization.typ"
#include "units/06-singular-value-decomposition.typ"