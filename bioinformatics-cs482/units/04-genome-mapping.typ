= Genome Mapping
== Sequencing
We get sequencing from either Sanger sequencing, Next Generation Sequencing, to produce DNA fragments. 

Long Reads (Pacbio/Nanopore) typically have a high error rate, and short reads (Illumina) have a bigger computational task.

== Assembly
The goal is to derive the original string from a collation of fragments. 

*Coverage*: Number of fragments overlapping for a specific position of the original sequence.

_Note_: If there is a lot of overlap between the end of one fragment and start of another, it is likely that they were overlapping. 

=== Long Read
1. Reads
2. Build overlap graph
3. Bundle stretches of the overlap graph into *contigs*
4. Pick most likely nucleotide sequence for each contig
5. Contig

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

Then, derive a consensus by using sequence alignment. 

=== Short Read
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

*Euler's Theorem*: Every balanced, strongly connected directed graph has a cycle that visits every edge exactly once.

Form a cycle by randomly walking in a graph, and not revisiting edges. While unexplored edges remain, select a node, newStart, in Cycle with unexplored edges and form a new cycle by traversing Cycle starting at newStart, then randomly walk to include new unexplored edges. 

Note that you can turn an Eulerian path into an Eulerian cycle by adding an edge between two unbalanced nodes making it a balanced graph.

*Graph Cleaning*: Remove "sink" nodes in De Brujin graph and combine divergence structures that converge to a single node later through the graph.

*Contig Assembly*: Use Euler algorithm to identify strongly connected regions in the genome and use thae path to determine the full contig.