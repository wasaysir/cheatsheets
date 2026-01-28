#import "@preview/summy:0.1.0": *

#set text(font: "Helvetica")

#show: cheatsheet.with(
  title: "BIOL 365 - Bioinformatics", 
  authors: "Wasay Saeed",
  write-title: false,
  font-size: 5.5pt,
  line-skip: 5.5pt,
  x-margin: 25pt,
  y-margin: 20pt,
  num-columns: 5,
  column-gutter: 4pt,
  numbered-units: false,
)

#set heading(numbering: (first, ..other) => {
  if other.pos().len() <= 0 and first > 1{ 
    return first - 1
}})

#include "units/01-intro.typ"
#include "units/02-pairwise-sequence-alignments.typ"
#include "units/03-scoring-functions.typ"
#include "units/04-databases.typ"