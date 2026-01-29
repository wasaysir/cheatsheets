= Phylogenetic Analysis

Term List:
\ Xenologs

Procedure:
+ Select sequence
+ MSA 
  - Determine scoring matrix for nucleotides or amino acids
  - Select your alignment method
  - Determine gap selection strategy
    - Important for phylogeny
    - Most treat it as missing data
    - Another is removing rows
    - Another is masking columsn (with lots of gaps)
+ Tree building
  - Pick scoring / evolutionary method
  - Choose between distance or character based methods
+ Tree evaluation
  - Are there xenologs (horizontal transfer) or substituted paralogs

== Stage 1: Selection of sequences
- For species trees, ensure you only touch the same species in different species (true orthologs)
- We don't want a paralog
  - To ensure it is an ortholog, you do a reciprocal BLAST hit (take the returned result and run it again, you should get original gene from starting organism)

- For gene trees, 

== Stage 2: MSA
- For DECIPHER MSA:
  + Initialization: Predict secondary structure for input protein sequences
  + Calculate guide tree based on kmers using order of kmers as well as number of shared kmers
  + Progressive alignment using scores on MIQS matrix (similar to BLOSUM0 and secondary structure states)
  + New guide tree (UPGMA), new progressive alignment
  + Repeated refinement by splitting a branch into two groups and aligning profiles before recombining

- MSA Editing:
  - You can delete/"clean" rows that have very noisy or missing data. 
  - DECIPHER includes MaskAlignment to identify and remove regions of MSA that have poor amounts of info.
  - 