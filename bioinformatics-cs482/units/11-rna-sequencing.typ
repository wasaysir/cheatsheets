= RNA Sequencing

\ Microarray Technology: Tool to determine gene expression levels by comparing expression of specific RNA sequences in cells under different treatments.

Procedure:
+ The chip is a glass slide with thousands of tiny spots with DNA probes (short known sequences of specific genes)
+ mRNA is extracted from cells
+ mRNA is converted into cDNA (complementary DNA) and tagged with fluorescent dyes. cDNA is created by placing reverse transcriptase on mRNA transcript.
+ Labeled cDNA is washed over the chip, and whenever cDNA matches DNA probe, it will hybridize (stick to it)
+ Machine shines laser on chip, and determines gene activity by fluorescent tags.

Advantages:
+ Can focus on small regions, even few molecules/cell

\ RNA-Seq Technology: More advanced version of RNA sequencing that doesn't tag to known sequences, but rather sequences actual RNA sequence.

Procedure:
+ Isolate mRNA
+ Remove DNA
+ Fragment RNA (slice into small pieces)
+ Reverse transcribe RNA into cDNA by Reverse transcriptase
+ Add ligate sequence adaptors (small tags to the end of the sequence)
+ Use PCR amplification to increase precision
+ Sequence cDNA using sequencer (like Illumina) to assign quality scores to individual reads

\ Expression Analysis Data Matrix:
Each vector contains an expression level for each gene. These vectors are collected for each experiment/condition, and combined to form a matrix. 

Each row in the matrix determines the *expression profile of a gene*. 

Comparing two columns compares different experiment similarities. 

#image("../assets/expression_analysis_data_matrix.png")

=== Analysis
By *clustering* in the Expression Analysis Data Matrix, we can determine hidden relationships between genes and experiments. 

By classification, we can extract features from data that best assign elements to well-defined classes.

\ Differential Gene Expression: Genes are expressed differently depending on certain conditions (conditions can be Time, Physiology, Health, Tissue, Individual, Species)

=== Gene Expression Estimation Challenges
- Sequencing runs with more depth will have more reads mapping to each gene
- Longer Genes will have more reads mapping to them
- Normalization is necessary to do differential expression estimation

\ RPKM: Reads per Kilobase Per Million

*Procedure*:
+ Find Read Count for gene
+ Find Total read count sum across all genes, and divide by 1 million
+ Divide gene read count by total read normalized read count
+ Divide by Transcript length divided by 1000

#image("../assets/rpkm.png")

However RPKM is biased if a few genes are abnormally expressed, that affects normalization. Further, a single gene can have multiple isoforms (alternative splicing, different transcription start sites, etc), which means reads can map to shared exons. Then it is difficult to tell just from read expression which isoform gene was expressed most. 

Instead of of finding gene expression, we can find transcript expression, and use the location of when they were expressed to find gene expression. 

=== Transcript Quantification
#image("../assets/transcript-quantification.png")

Since each read is additive, we want to optimize weights for each transcript by minimizing:

$
  min_(w_1, dots, w_T gt.eq 0) sum_(p in P) (R_p - sum_(t=1)^T w_t dot D_(t, p))^2
$

$P$ set of considered genomic positions. $R_p$: Observed read coverage (number of reads covering position $p$). $D_(t, p)$: Expected read coverage for transcript $t$ at position $p$.

*Quant*: This algorithm is similar to unsupervised clustering algorithms, or EM in general, where we first optimize the transcript weights, and then optimize the profile weights repeatedly until we converge. 

=== Statistical Analysis
\ P-Value: Probability of obtaining result at least as extreme as the one observed, given that null hypothesis is true.

Null hypothesis $H_0$: Gene has same expression level in two groups

Alternative Hypothesis $H_1$: Gene has different expression levels

Small p-value rejects null hypothesis. 

Statistical analysis of genes: We cannot run hypothesis testing on each gene individually, since we'd expect around $p%$ to be wrong. Instead, we need to adjust p-values in multiple testing setting. 

\ MA plot: Compare log ratio (how much gene changed between two conditions) and mean average (overall expression). Large changes given low expression ar eless significant, so MA plots reflect that uncertainty.

#image("../assets/ma-plot.png")

\ Volcano Plot: Compares log ratio to p-value (statistical significance of change). Ideally you'd have a large change tied to statistically significant change. 

#image("../assets/volcano-plot.png")

\ Simpson's paradox: Trend appears in groups of data but disappears when groups are combined.  