= Genome Annotation

\ Structural Annotation: Identify locations of genes in a genome (aka gene prediction)
\ Functional Annotation: Determine functions of genes

== Gene Prediction
Get set of genes and observe them, try to find what's common between them, and search the genome foor these patterns.

== Structural Annotation

Given a set of genes, identify a pattern and search the genome for the pattern.

*Key Components of Gene Structure*:
- Untranslated Region: 5' & 3' regions of mRNA that are transcribed but not translated (for regulation of translation, mRNA localization, and stability.)
- Poly-A Tail: Adenisone nucleotides on 3' end of eukaryotic mRNAs for stability, nuclear export, and greater translational efficiency.
- Intron: Non-coding Segments in coding region (removed in splicing)
- Exon: Coding sequence in mature mRNA.

*Regulatory Elements in Genome Annotation*:
- Transcriptional Factor Binding Site: DNA sequence where transcription factors bind. Crucial for regulating gene expression by binding or blocking transcriptional machinery.
- Promoter: Region upstream of transcription start site for RNA polymerase and associated factors to start transcrption.
- Enhancer: Can be far from gene (Works by looping DNA to interact with promoters, enhancing transcription)

- Donor (5' Splice Site): Located at 5' end of intron (Typically has GU dinucleotide)
- Acceptor (3' Splice Site): Located at 3' end of intron. (Typically has an AG dinucleotide)
- Branch Point (Adenine Nucleotide upstream of acceptor site used for lariat formation during intron removal)
- Lariat: Looping of DNA to clip Intron.

*Splicing Mechanisms*:
- Exon Skipping: Selective removal of 1+ exons
- Alternative 5'/3' splice sites: Vary exact splice site
- Mutually exclusive exons: Only one exon from a pair is included in mature mRNA
- Intron Retention: As intron remains in mature mRNA, sometimes for regulatory function
- Regulatory Factors: Controlled by cis-elements [on same molecule as regulated gene] (Splicing enhancers/silencers) and trans-acting splicing factors (SR proteins, hnRNPs)

\ Spliceosome: Complex of small nuclear RNAs and proteins facilitating splicing

\ Gene Family: Set of genes originated from common evolutionary ancestor (Ex. Homology). To find what gene family a gene belongs to, a simple solution is BLAST, but it suffers from same shortcomings as gene prediction. 

\ Open Reading Frame: Continous stretch of protein-encoding codons. Starts with ATG and ends with stop codon (TAA, TAG, TGA). There are 3 possible frames in a DNA strand, 6 in double-stranded. Note ORFs can be nested within a longer ORF, but they get blocked. Also we should exclude ORFs that are too short (300 bp)

We can predict introns by looking for a pattern: GT....A..AG

To find a gene we look for the following:
- ATG
- GT (Intron Start)
- A (Near Intron End)
- AG (Intron Stop)
- TAA/TAG/TGA (Exon Stop)

\ Sequence Motifs: Short, discrete sequence patterns indicating certain biologial functions.

Problems with hard-coded sequence motifs:
- They are too short, and these short sequences can occur randomly in genome.
- Exceptions (Some genes have alternative start codons, ORFS can be short)
- Errors in DNA sequencing
- Some features don't have discrete sequence motifs.

Gene Sequences are probabilistic:
- First 3 bases are 99% likely to be ATG
- First 6 bases upstream of coding region have 75% probability to be GACACC (Kozak Sequence)
- 90% prob of TATAAA sequence within 100 bp upstream of gene
- CG dimers are 50% higher frequency in 500 bp window before gene than genome avg.

== Gene functional annotation
Once we've identified these structures, we can perform functional annotation (assign genes to gene families)
\ Gene families: Set of genes that originate from common evolutionary ancestor. Given observed traits, group organisms on evolutionary relationships from these traits and have gene families depend just on gene, rather than whole genome.

== Calculating Probabilistic Genome Frequency
When encountering a motif, if it is a gene, the probability of finding a relevant motif in downstream region is higher, if not, probability is lower. We can use this approach to determine if something is a gene.

Given aligned sequences, it's easy to compute a profiling matrix:
- Given a series of sequences, calculate the probability of X nucleotide at position I for all nucleotides and all positions. (ex. having nucleotide "A" at position 4)

#image("../assets/gene-probability.png")

Then, given a sequence, calculate the likelihood of getting the sequence given it is a gene (using profiling matrix). Then calculate the likelihood given the genes aligned randomly. This is the null hypothesis. Then, comparing the two likelihoods you can determine whether it is likely to be a gene or not.

Markov Model:
\ Markov Property: System's future state is influenced by present state, not past.
- Given base frequencies are linked to recent context, we use a Markov model to calculate probability of getting a nucleotide given the previous $x$ nucleotides)

#image("../assets/markov-calculation.png")

\ Markov Chain: Sequence of events, each dependent on previous state.

== Simplifying Code to Gene Mask
We want to predict whether a site is "in a gene" or "non-gene", but that is a hidden state.

- If a hidden state changes between each other, that is a transition (non-gene => gene, gene => non-gene, gene stays gene)
- Hidden states can influence probability of observations (emission) [Ex. In genes we see more C and G than in non-genic regions]

Then each emission has a probability (eg. P(G|0)) and each transition has probability (P(0->1))

*Hidden Markov Models*:
1. Alphabet $Sigma$ of emitted symbols
2. Set of hidden states
3. A $abs("States") times abs("States")$ transition matrix
4. A $abs("States") times abs(Sigma)$ emission matrix

For each state $l$, transition probabilities must sum to 1. Same with emission probabilities.

*Visualization*: 
- Solid nodes represent hidden states. Every pair of states is connected by solid directed edge labeled with transition probability.
- Dashed nodes represent alphabet symbols. Each state is connected to every symbol node by dashed edge labeled with emission probability.

#image("../assets/hmm-visualization.png")

*Example*:
Given path $pi = pi_1 dots pi_n$ and emitted string $x = x_1 dots x_n$, $Pr(x, pi) = Pr(x | pi) dot Pr(pi)$ and $Pr(pi) = product^n_(i=1) Pr(pi_(i-1) arrow pi_i)$. $Pr(x|pi) = product^n_(i=1) Pr(x_i | pi_i)$, therefore $Pr(x, pi) = product^n_(i=1) "emission"_(pi_i)(x_i) dot "transition"_(pi_(i-1), pi_i)$

\ Decoding Problem: Given emitted string from HMM, how do we find the hidden path that maximizes the probability.

*Viterbi Graph*:
 - Create $abs("States")$ rows
 - $n$ columns (one for each symbol in $x$), where node $(k, i)$ represents being in state $k$ after emitting $i^"th"$ symbol
 - Each edge from $(l, i-1)$ to $(k, i)$ has weight $"transition"_(l, k) dot "emission"_k(x_i)$
 - Source node is created with $pi_0$ as silent initial state, and a terminal sink node at the end with edge weight $1$ for each node.

 *Viterbi Algorithm*:
 - $s_(k, i)$ is maximum product weight of path from source to node $(k, i)$
 - Recurrence is $s_(k, i) = max_(l in "states") (s_(l, i-1) dot "transition")_(l, k) dot "emission"_k(x_i)$
- First column has $s_"source" = 1$
- $S_"sink" = max_(k in "states"){s_(k, n)}$

Since maxing product is equal to maxing sum of logs, one can take logs of all weights and solve longest-path problem in resulting weighted DAG.

To find overall probability that HMM emits a particular string $x$, calculate Probability of emission given path for all possible paths in HMM.

HMMs can also be used for homology search, where an HMM profile is a probabilistic model including probabilities of sequence variants (nucleotides or amino acids)