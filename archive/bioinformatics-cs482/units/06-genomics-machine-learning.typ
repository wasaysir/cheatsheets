= Machine Learning in Genomics

/ Genomic Signature: Unique frequency of oligonucleotide chains within a genome

/ DNA Barcoding: Identifying a species by a characteristic sequence of a standard short section of DNA in genome.

/ Convolutional Neural Networks: Designed for structured data w/w spatial bias

/ Maxpooling layer: Convolutional layer that takes largest value in pool

== DNA Barcoding
Identifying species based on short, standardized region of DNA by colelcting sample; extracting DNA from sample; amplifying specific gene region (barcode) using PCR. [For animals we use mitochondiral COI gene]. Sequence the barcode region. Compare sequence to reference database to identify the species.

== Applications

/ Transcription Factors and RNA-binding proteins: Regulating factors of genes by binding to DNA/RNA

Splicing defects, genetic mutations, pathogenic variants, can all lead to improper genome sequencing, which is a hurdle for accurate DNA barcoding. 

/ SpliceAI: Deep Learning model trained on GENCODE-annotated exon-intron boundaries; With large sequence window it is able to learn splicing patterns, and identify pathogenic splicing mutations.

/ DeepBind: Deep Learning Model using CNN to identify where along gene sequences proteins (Transcription Factors) are most likely to bind. Then, with this model you can predict bind affinity for new sequences.

/ DeepVariant: CNN-based model trained on labeled sequencing data; converts aligned reads to images; predicts substitutions and indels with high precision and recall.

== Evaluation
Training Set: ~60-80% of data
Validation: Used to tune hyperparameters (10-20% of data)
Test: Used to assess performance (10-30% of data)

/ Type 1 Error: Predicted Positive, Actually Negative
/ Type 2 Error: Preidcted Negative, Actually Positive

/ Precision: Sum of True Positive over all predicted positive
/ Recall (Sensitivity): Sum of True Positive over all Actually Positive
/ Specificity: Sum of True Negative over all Actually Negative

/ Accuracy: Sum of Correct estimations over all predictions

/ F1 Score: $1/(1/"Recall" + 1/"Precision")$