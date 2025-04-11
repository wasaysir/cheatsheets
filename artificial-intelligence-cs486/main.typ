#import "@preview/summy:0.1.0": *

// #set text(font: "Helvetica")

#show: cheatsheet.with(
  title: "CS486", 
  authors: "Wasay Saeed",
  write-title: false,
  font-size: 5.5pt,
  line-skip: 5.5pt,
  x-margin: 30pt,
  y-margin: 30pt,
  num-columns: 5,
  column-gutter: 4pt,
  numbered-units: false,
)

#set heading(numbering: (first, ..other) => {
  if other.pos().len() <= 0 and first > 1{ 
    return first - 1
}})

#include "units/00-general-formula.typ"
#include "units/01-agents.typ"
#include "units/02-search.typ"
#include "units/03-constraints.typ"
#include "units/04-logic.typ"
#include "units/05-supervised.typ"
#include "units/06-reasoning-under-uncertainty.typ"
#include "units/07-learning-with-uncertainty.typ"
#include "units/08-neural-networks.typ"
#include "units/09-planning-with-uncertainty.typ"
#include "units/10-reinforcement-learning.typ"