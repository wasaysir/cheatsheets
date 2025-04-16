#import "@preview/lovelace:0.3.0": *

= Sequence Alignment

== DNA Errors

\ Substitution: Flip one base for another (Mismatch Error) \
\ Indel: Insert/Delete base in sequence (Gap Error) \
\ Transition: Replace a Purine with a purine; replace pyrimidine with pyrimidine. \
\ Transversion: Convert Purine to pyrimidine, vice versa. More expensive than transitions \
\ Transposon: Delete/Insert whole region from sequence and insert to another

== Similarity Heuristics
\ Hamming Distance: Number of different positions within string
_Ex_: ATCTCA vs ATCACA is 1 \
\ Normalized Hamming Distance: $"Hamming Distance" / "len(Seq)"$ (Assume sequences same length)
\ Edit Distance: Minimum-weight series of edit operations transforming $a$ into $b$
_Ex_: TGCAGT TCACAGT (Switch G to C, remove A, d= 2)
\ Substitution Matrix: Cost of switching one base to another (since transitions and transversions cost different amounts)
\ BLOSUM62: Most classical amino acid substitution matrix

#image("../assets/blosum62.png")

\ Levenshtein Distance: Number of edits (indels + substitutions) \

\ Dynamic Programming: Reduce problems into subproblems to save results and reduce repeated computations. 
- Requires optimal substructure (optimal solution contains optimal solutions to subproblems)
- Overlapping subproblems: Solution contains set of distinct subproblems repeated many times
- No Greedy Choice: Requires tracing back through many choices

== Pairwise Sequence Alignment
\ Pairwise Sequence Alignment: Arrange two sequences so similar regions are aligned to each other.

#image("../assets/pairwise-sequence-alignment.png")

=== Global Alignment
*Solves Global alignment* (Overlap two entire sequences completely) \
*Time & Space Complexity*: $O(m n)$ \
*Needleman-Wunsch*:
#pseudocode-list[
  + *Input*: Sequences seq1, seq2, match score ($alpha$), gap penalty ($mu$), mismatch penalty ($sigma$)
  + *Output*: Alignment score, backtrack array
  + Initialize alignment + backtrack array of size seq1, seq2
  + Initialize top row and left column base cases
  + For every cell in matrix
    + if matching bases then add match score to score of left diagonal
    + if top/left cell + gap penalty is lowest score, add it
    + if left diagonal + mismatch penalty is lowest score, add it
    + put direction taken in backtrack array
  + output alignment score at bottom right cell, and use backtrack array to derive original alignment
]

#image("../assets/needleman-wunsch-matrix.png")
#image("../assets/needleman-wunsch-traceback.png")
#image("../assets/needleman-wunsch-algo.png")
#image("../assets/needleman-wunsch-traceback-algo.png")

==== NCBI BLASTn Scoring scheme
Because whole regions get inserted/deleted, having $n$ bases indeled is less costly than $n$ indels. So we make gap opening a high cost, and continuing gap lesser cost.

*Consant*: Gap Penalty = Constant for all size $n$ \
*Linear*: Gap Penalty = Gap Length x Gap opening \
*Affine*: Gap Penalty = Gap Opening + Gap Extension x (Gap Length - 1) \
*Convex*: Gap Penalty <= Affine Gap Penalty \

\ NCBI Blastn Scoring Matrix:
#table(
  table.header(
    [*Event*], [*Score*]
  ),
  columns: 2,
  [Match], [+2],
  [Mismatch], [-3],
  [Gap opening], [-5],
  [Gap extension], [-2],
)

=== Local Alignment
\ Smith-Waterson: Same as *Needleman-Wunsch* but we can start and end anywhere, and the goal is to find the lowest cost path overall.
0 is minimum, so initialize every cell as minimum of a continuation of path and 0, and the highest score is the ending of the alignment. To retrieve, we start at highest cell and go back until we reach 0. 


=== Comparison
*Global Alignment: Needleman–Wunsch Algorithm*

- *Initialization*: Top-left, i.e. $M(0,0) = 0$  
- *Iteration*:  
  $$
  M(i,j) = \max\Bigl\{
    M(i-1,j) + \text{Gap},\,
    M(i,j-1) + \text{Gap},\,
    M(i-1,j-1) + S(i,j)
  \Bigr\}
  $$
- *Termination*: Bottom-right  
- *Traceback*: Start from bottom-right and end at top-left  

*Local Alignment: Smith–Waterman Algorithm*

- *Initialization*: Top row/left column ($M(0,j)=0$ and $M(i,0)=0$)
- *Iteration*:
  $$
  M(i,j) = \max\Bigl\{
    0,\,
    M(i-1,j) + \text{Gap},\,
    M(i,j-1) + \text{Gap},\,
    M(i-1,j-1) + S(i,j)
  \Bigr\}
  $$
- *Termination*: Anywhere  
- *Traceback*: Start from the highest-scored cell and end when $M(i,j)$ is 0.  

=== Database Search
\ k-mer: Continuous block of $k$ characters (def. 11 for nucl and 3 for prot) \
\ High-Scoring Segment Pair: Alignment found by BLAST word match

\ BLAST: 
#pseudocode-list[
  + Build sequence into *k-mers* (continuous block of $k$ characters)
  + For each k-mer build index hash table of occurrences of all k-mers in target string
    + In construction of k-mers, allow some deviation along threshold of difference
  + Given a query, break it into k-mers and look up each k-mer as seed for sequence alignment
  + For each seed, extend seq until alignment falls below threshold
]

==== Variations
\ Gapped BLAST: Extensions are in BLAST are allowed to use gaps. (So take gaps and continue aligning after the gaps)
\ Two-hit Seeding: You can only extend a sequence if there is another sequence nearby it. 
  - Finding two-length words is more likely than a full word, so it's more sensitive.

==== Scoring
\ Raw Score: Alignment score $(S)$ of string \
\ P value: Probability of alignment score $gt.eq S$ given random strings \
\ E value: Expected number of alignments with score $gt.eq S$ given random strings \

==== Alignment Scoring
- Used to compare alignments of same query-reference pair
- Used to compare alignments of diff query-reference pair
  - Determine whether (Q1, R1) or (Q2, R2) is more likely a homology
- Used to indicate confidence of alignment
  - Indicates whether alignment (Q1, R1) is actually homologous

===== Comparing Alignment of same query-reference pair
Define match ($p$), substitution ($q$), indel ($r$) probability. 
Probability is $p^m q^s r^i$, log-prob = $m log(p) + s log(q) + i (log) r$ $m, s, i$ are number of matches, substitutions, indels respectively.

*Problems*: 
- Longer spotty seq's are penalized more than shorter perfect seq's
  - TGCAT_AG_GAT is very close to CCGTA_AG_AT, whereas TGCAGTAGGAT is scored worse than CCCACGAG-AT
- Repeated information is penalized (even though it's functionally the same)
  - TCAGT aligning to TCGGT is better than TCAGTTCAGT aligning to TCGGTTCGGT

===== Comparing Alignment of diff query-reference pair
\ Homology Model: Assume alignment reflects evolution
\ Random Model: Assume alignment spurred randomly

====== Homology Model
Probability: $Pr(x, y | H)$ \
Assume $p_(a b)$ is probability evolution gave char $a$ in $x$ and char $b$ in $y$
$P(x, y | H) = product^n_(i=1) p_(x_i y_i)$

====== Random Model
Probability: $Pr(x, y | R)$ \
Assume $p_a$ is probability to randomly get char $a$
$P(x, y | R) = product^n_(i=1) p_(x_i) Pi^n_(j=1) p_(y_j)$

====== Likelihood Ratio
Likelihood Ratio: $P = Pr(x, y | H) / Pr(x, y | R) = sum_i log(p_(x_i y_i)/(p_(x_i) p_(y_i)))$ \
Alignment score: $log(P)$

====== Substitution Matrix
A matrix used to contain the unique probabilities of switching out one character for another. \
*BLOSUM62* is empirically found values on actual probabilities of switching out amino acids. 

To calculate $p_(x_i y_i)/(p_(x_i) p_(y_i))$ take a toy database of values, and calculate probability of getting pair $(x, y)$ over all possible pairs in sequences (Number of pairs $(x, y)$ over number of all pairs) and then divide that by probability of getting $x$ and $y$ individually (number of $x/y$ over all base pairs in list). Then substitution matrix only takes log values, so take the log.

#image("../assets/substitution-matrix-formulation.png")

====== Derivation of BLOSUM62
- Some protein families (like hemoglobin) are well-studied and will be overrepresented in our databases, so to create a matrix that properly reflects priors, we calculate similariy scores between sequences, and those with similarity scores greater than 62% are grouped together. The total weight of a group is $1$, so if we have $x, x', y$ where $x, x'$ pass similarity threshold, but $y$ doesn't, then $x, x'$ each have weight $0.5$ but $y$ has weight $1$. This is useful for creating a more representative protein database.

We can use substitution matrix to simplify calculating values $sum_(x_i, y_i in "Sequences") s(x_i, y_i) = log(P)$

=== FASTA Format

> Title (Usually accession ID, Product, Organism)
Sequence

- Sequences are standard IUPAC codes
- Lowercase allowed but mapped to uppercase
- Numbers not allowed in sequence

==== Alignment-Free Sequence Comparison
Given 2 sequences, chop them up into kmers. Then create a union between these two kmer lists. Then, create a word count of each kmer into a vector of the combined kmer list. Then take Euclidean distance between the two for a score.

#image("../assets/alignment-free-similarity.png")

==== Open Vocabulary Problem (Byte-Pair encoding)
To increase ability to scan sequence, take index of k-mers, sorted by frequency, and add that as a new "character". Iteratively, we reduce the number of tokens to scan.

==  Multi-sequence Alignment
Align $k$ sequences 

=== Sum-of-Pairs
Do pairwise sequence alignment for every pair of sequences, and take the sum for a global alignment score, then optimize over that MSA for the alignment.
Takes $O(n^2 k^2)$ time, because there are $binom(k, 2) = 1/2 k(k-1)$ pairs of alignments

=== Centre-Star Method
Choose one sequence as center sequence by doing Pairwise Sequence Alignment on all pairs and find one sequence that has maximum of all alignment scores to be the center. This takes $O(k^2 n^2)$ time.

Then combine all the sequences by determining the gaps in each sequence at which position, and then insert them in every sequence. Ex: AC-GA, TC-AG, A-TCG => A-C--GA, T-C--AG, A-T--CG

This doesn't really concern alignment between non-centre sequences.

#image("../assets/center-star.png")

=== Progressive Alignment
Greedy algorithm that is a heuristic that doesn't visit all solutions but still gives good answer.

Do pairwise alignment on all sequence pairs, $O(k^2 n^2)$. Then build distance matrix among sequences via some heuristic. Then build a guided tree by some clustering algorithm and then select some starting sequence according to some optimal criteria (e.g. sequence most similar to rest), and align between node pairs, merging recursively for $k-1$ alignments.

==== Distance Matrix
Matrix with zero on diagonal, and non-negative values, symmetric, and satisfies triangle inequality. The values at coordinate $i, j$ are just distances between sequence $i$ and sequence $j$. Distance matrix is built from some heuristic: Hamming dist, Levenshtein dist, Substitution matrix-based dist.

=== Aligning new sequence
Then, if we have a new sequence to add, we gather our alignment of all the sequences, and capture the frequency of each possible character at each position for each character. Then the new "sequence" is the greatest frequency at each position, which you align to.  

#image("../assets/multi-sequence-group-alignment.png")

=== Applications of MSA
- Motif Finding: Detect conserved regions of a protein family as important motifs
- Structure Prediction: Alignment to protein family help to predict protein structure better
- Phylogeny: Phylogeny helps better examine evolution history among organisms