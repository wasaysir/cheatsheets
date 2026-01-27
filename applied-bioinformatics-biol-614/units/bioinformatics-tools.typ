= Bioinformatics Tools & Techniques
/ Uniprot: Database for protein sequences and functions
In BLAST, you have query type and result type. blastn has nucelotide query type and nucleotide return type. blastp does protein query and return type. blastx does searches protein structures with a nucleotide sequence. It checks all six reading frames (3 forward and 3 backward [3 for each start of the translation]). tblastn does nucleotide query to protein result. 

In BLAST, the default database covers all the other ones. pdb is just for protein sequences. RefSeq is for high-quality curated subset of protein structure data (smaller).

You can use organism to pick a specific taxonomic group (or organism itself) to restrict your search space. 

PSI-BLAST is for iterative searching which takes your first BLAST profile and can do a separate subsequent search based on that homolog and continue to find remotely distant proteins. 

In graphical summary you'll get the query sequence at the top and then super hits for protein domains below. 

Below that is the hit distribution where colours represent quality of alignment scores. 

In the description you get a list of all the hits. The max score is a bit value for the calculation and the E.Value is the expected number of hits with that score. Similar to p-value. Query coverage shows how well homologs cover query sequence. Percentage identity is how many base pairs are identical. 

Positives is the sequence similarity which includes similar amino acids, not just identical. 

/ Paralog: Genes with common ancestor separated by gene duplication
/ Homolog: Genes with common ancestor  
/ Ortholog: Genes separated by specieation (same gene, but for different species)

Downloading fasta_complete gets the complete protein sequence, whereas the fast_aligned gets only the alignments to the query sequence.

Use Seaview for multi sequence alignment viewing. 

When there's some sequences in the MSA that seem to hav elots of gaps where other alignments have a match, it can make sense to delete them to avoid issues with the phylogenetic tree generation. This is more of an art than a science, so be careful with this.

In Seaview you can use bootstrapping on tree construction to determine a confidence level of the tree. 

/ Consurf : Tool to view areas of conservation on a 3D protein structure.
