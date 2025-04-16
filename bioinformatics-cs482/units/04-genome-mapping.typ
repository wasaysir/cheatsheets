= Genome Mapping
== Sequencing
We get sequencing from either Sanger sequencing, Next Generation Sequencing, to produce DNA fragments. 

Long (>10000 bp) Reads (Pacbio/Nanopore) typically have a high error rate, and short reads (Illumina) have a bigger computational task, but higher accuracy.

== Assembly
The goal is to derive the original string from a collation of fragments. The original string is first copied multiple times, and then fragmented, so there's no guarantee that the fragments are one after another.

*Coverage*: Number of fragments overlapping for a specific position of the original sequence.

_Note_: If there is a lot of overlap between the end of one fragment and start of another, it is likely that they were overlapping in the actual genome. 

=== Long Read
1. Get Reads
2. Build overlap graph
3. Bundle stretches of the overlap graph into *contigs*
4. Pick most likely nucleotide sequence for each contig
5. Output Contigs

*Contig*: Set of DNA segments that overlap in a way that provides contiguous representation of genomic region.

*k-mer composition*: Collection of all k-mer substrings of the Text, including repeats.

*k-mer Prefix/Suffix*: First/Last $k-1$ nucleotides of k-mer

Then connect all k-mers of the text in a graph, where for given (Text) nodes with Suffix(Text) = Prefix(Text') should have an edge between them.

Then, to solve this problem, we want a Hamiltonian path (going through every node) to solve, so we can use heuristics to solve. 

For instance, remove transitively-inferrible edges, edges skipping one or two nodes.

#figure(
  image("../assets/layout.png"),
)

Then, create a contig for all non-branching stretches.

#figure(
  image("../assets/contigBranch.png")
)

Then, derive a consensus by taking all reads tha tmake up a contig and line them up and take consensus (i.e. through majority vote).

=== Short Read Assembly
1. Error Correction
2. Graph Construction
3. Graph Cleaning
4. Contig Assembly
5. Scaffolding
6. Gap Filling

*Error Correction* means preprocessing reads to find errors and only accepting exact matches and try to replace rare k-mers with common k-mers.

==== De Brujin
*Graph Consruction*: 
Given collection of k-mers $P$, define nodes as all unique $k-1$-mers that are prefixes or suffixes of k-mers in $P$ and for each k-mer in $P$ create a directed edge from its prefix to its suffix.

#image("../assets/de-brujin.png")

*Euler's Theorem*: Every balanced, strongly connected directed graph has a cycle that visits every edge exactly once.

Form a cycle by randomly walking in a graph, and not revisiting edges. While unexplored edges remain, select a node, newStart, in Cycle with unexplored edges and form a new cycle by traversing Cycle starting at newStart, then randomly walk to include new unexplored edges. 

Note that you can turn an Eulerian path into an Eulerian cycle by adding an edge between two unbalanced nodes making it a balanced graph.

*Graph Cleaning*: Remove "sink" nodes in De Brujin graph and combine divergence structures that converge to a single node later through the graph.

*Contig Assembly*: Use Euler algorithm to identify strongly connected regions in the genome and use that path to determine the full contig.

=== Computational Problems in Sequencing Data
- Read Mapping/Alignments: Map/align reads/fragments back to known genome
- Variant Calling: Detect positions varying from reference population
- Genome Assembly: Reconstruct full chromosome from short/long sequencing reads/fragments

/ Seed-and-extend: To find target regions on reference genome that are at most $k$ mutations between read and target build alignment from seed regions instead of global/local alignment.

== Indexing Data Structures
=== K-mer index
Generate list of words of length $k$ in genome string. For each kmer build index table with all occurrences in the reference, and for each kmer of query, find its hits in the index table.

=== Suffix Tree
/ Suffix: Substring $S_i$ of $s$ starting at position $i$.

- Start with full string $S$ and empty root.
- Add each suffix successively and label leaf with position.
- Use existing edges where possible.
- Merge edges that have no branches and concatenate labels for better space efficiency.

Pattern Matching: To see if query string $Q$ is substring of $S$, start at root and traverse tree according to query.
Longest Common Substring: Build substring for concatenated string $S \# Q \$$ and label leaves depending on whether suffix belongs to $S$ or $Q$. Common substrings, as internal nodes, are prefixes of two suffixes from both $S$ and $Q$, so find node with longest path to the root.

#image("../assets/suffix-tree.png")
#image("../assets/longest-common-substring.png")

=== Suffix Array
Sorted list of all suffixes of string $S$.

- Made by generating list of suffixes, sorting them in lexicographical order. $A[k]$ is start position of $k$-th least-sorted suffix.

#image("../assets/pattern-matching-suffix.png")

=== Burrows-Wheeler Transformation
Lossless string compression algorithm, made by generating all rotations of string $S$, sorting rotations lexicographically, and keeping only last column as output. Can be further reduced by run-length encoding.

Note that we rotate to the left, so TAGAGA\$ becomes AGAGA\$T

Three ways of inverting:
/ Sort and add: Given Iteration $i$ sort lexicographically, then add original BWT to beginning. Continue until you reach same length as input string, and take string with \$ at the end. Each iteration takes $O(n log n)$, so total complexity is $O(n^2 log n)$

==== LF-Mapping
/ First-last property: $k$-th occurrence of a symbol in First Column and $k$-th occurrence of symbol in Last Column correspond to the same position of this symbol in Text.

Last column is the BWT, first column is the sorted characters of BWT. 

==== FM-Index Pattern Matching
Combines BWT for compression and suffix array for efficient search. 

C array has $C[c]$ = total number of occurrences of characters $< c$ in $F$ (sorted characters)
O matrix has $O[c, k]$ = number of times c occurs in $L[1:k]$ (Start from index 1)

#image("../assets/fm-index.png")

To pattern match, do the following:
#image("../assets/fm-index-pattern-match.png")

=== Comparison
#table(
  columns: 5,
  table.header([], [kmer index], [suffix tree], [suffix array], [BWT & FM Index]),
  [Space], [$O(R)$], [$O(R)$ with pointers], [$O(R)$], [$O(R)$],
  [Search Time], [$O(q)$], [$O(q)$], [$O(q log R)$], [$O(q)$]
)