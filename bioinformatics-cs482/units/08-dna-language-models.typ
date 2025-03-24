= DNA Foundation Models

\ Language Model: Predict next word based on context by finding context-aware word representations.

\ Pre-Trained Language Model: Deep Learning models trained on big datasets to learn linguistic patterns and representations

\ Large Language Model: Large-sized pretrained language model

\ Statistical Language Model: Probabilistic Model

\ Neural Language Model: Neural Networks to predict likelihood of sequences of words

\ Foundation Model: Deep Learning Model trained on large datasets to be applicable in many use cases.

LLMs have way more parameters; more emergent abilities; require ridiculous amounts of resources; and have more powerful features than regular Language Models

Benefits of Transformers are dynamic computation (information is context-specific), good memory usage, parallelizability.

\ Self-Supervised Representation Learning: Given unlabeled data, generate pseudo-labels by designing a proxy task to produce targets based on patterns in data. 

For example, given an image, you can "remove" certain sections, run your encoder + decoder to get a prediction of that removed section, and then compare the true removed section to the prediction. (No provided labels, but supervised learning occurs)

*BERT vs GPT Transformer Architectures*:

\ Masked Language Model: LM trained to predict masked/missing words within text, using surrounding context to find structure.

\ Autoregressive LM: LM trained to predict next word in sequence based on previous words, "autoregressively" calculating by using previous predictions.

\ Discriminative Model: Separate data in to different classes

\ Generative Model: Generating new data points

#table(
  columns: 3,
  table.header([], [BERT], [GPT]),
  [Training], [Masked LMs], [Autoregressive LMs],
  [Model Type], [Discriminative], [Generative],
  [Pretrain Task], [Predict masked words], [Predict next word],
  [Direction], [Bidirectional], [Auto-regressive]
)

Bidirectional model means "future" tokens affect previous token probability (DP), auto-regressive means only past affects future (Greedy)

== Building Foundation Models
Instead of creating a custom task-specific model, we can create a general-purpose trained model that is pre-trained, and then fine-tune for the task we want with shorter computation required.

\ K-mer Tokenization: Split sequence into sequence of kmers, which are then mapped to an index. 

Problem: K-mer size can grow exponentially, so instead we fine a new vocabulary based on training data via Byte-Pair Encoding. 

Once we have a BPE, given a new text, we start with a set of characters, and assign merge rules to reach our BPE tokenization.

== Applications

*DNABert:* Pre-Trained BERT for DNA sequences based on human references genome using overlapping k-mer tokenization. Goal: Wide-ranger applications (promoter region/transcriptional factor binding site/splite side prediction)

*BarcodeBERT*: Pre-trained BERT for DNA sequences based on Barcode data using non-overlapping k-mer tokenization for taxonomic classification.

DNA transformer design choices: Overlapping Kmers tokens, Non-overlapped, Byte-pair encoding. 

== Hyena Operators

To avoid the quadratic operation in tokens through Attention, they use Convolutions instead, in the Transformer-like-block.

== Eukaryotic DNA Terminology

\ Splicing: Post-transcriptional modification, removing specific introns to create a mature mRNA for protein synthesis.

\ Promoters: Regulatory sequence next to start codon enhancing transcription.

\ Enhancer/Silence: Far away sequences modifying frequency of transcription of DNA.

\ Insulator: Regulatory sequences ensuring enhancers and promoters don't promote other genes it's not supposed to.

\ Nucleosome: Region of DNA wrapped around histones.

== Benchmarking tasks

\ Nucleotide-wide tasks: Check each base pair one by one for accuracy

\ Sequence-wide tasks: Check the entire sequence for correctness

\ Binned tasks: Checking if specific segments of DNA (as one block) are correct.