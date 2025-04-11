= RNA Protein Folding

Condensed DNA is stored in a Chromatin chain. Each chromatin is a seires of nucleosomes (DNA coiled around 4 histones). In between histones are epigenetic marks (methyl) to influence gene expression.

RNA structure has three forms: Sequence (chain), Secondary Structure (loops within RNA), Tertiary structure (3D conformation)

#image("../assets/rna_structure.png")

== RNA Folding

#image("../assets/parenthesis_folding.png")

Nussinov Algorithm:
Construct matrix of RNA string by RNA string and initialize diagonal to 0, and lower diagonal to 0 as well. Each coordinate $(i, j)$ in the matrix should contain the maximum score for sequence between $S_i$ and $S_j$. 

For each cell, we follow this structure:
#image("../assets/nussinov_pairings.png")
#image("../assets/nussinov_recurrence.png")

To traceback, simply go to top-right cell, and then find optimal structure by tracing arrows with high scores or diagonal arrows in the cell.