#import "@preview/summy:0.1.0": *

#set text(font: ("Helvetica", "Cabin"), fallback: true)

#show: cheatsheet.with(
  title: "CS488 - Graphics", 
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

#include "units/00-formulas.typ"
#include "units/01-history.typ"
#include "units/02-devices.typ"
#include "units/03-device-interfaces.typ"
#include "units/04-geometries.typ"
#include "units/05-affine-geometry.typ"
#include "units/06-windows-and-viewports.typ"
#include "units/07-clipping.typ"
#include "units/08-projections.typ"
#include "units/09-rendering-pipeline.typ"
#include "units/99-opengl.typ"
