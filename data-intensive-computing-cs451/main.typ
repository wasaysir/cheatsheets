#import "@preview/summy:0.1.0": *

#set text(font: "Helvetica")

#show: cheatsheet.with(
  title: "CS451 - Data Intensive Computing", 
  authors: "Wasay Saeed",
  write-title: false,
  font-size: 5.0pt,
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

#include "units/00-bigdata.typ"
#include "units/01-distributed-file-system.typ"
#include "units/02-mapreduce.typ"
#include "units/03-Spark.typ"
#include "units/04-scala.typ"
#include "units/05-text.typ"
#include "units/06-graphs.typ"
#include "units/07-data-mining.typ"
#include "units/08-relational.typ"
#include "units/09-streaming.typ"
#include "units/10-mutable.typ"

#include "units/99-assignments.typ"