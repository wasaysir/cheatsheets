= DNA Foundation Models

\ Language Model: Predict next word based on context by finding context-aware word representations.
\ Pre-Trained Language Model: Deep Learning models trained on big datasets to learn linguistic patterns and representations
\ Large Language Model: Large-sized pretrained language model
\ Statistical Language Model: Probabilistic Model
\ Neural Language Model: Neural Networks to predict likelihood of sequences of words
\ Foundation Model: Deep Learning Model trained on large datasets to be applicable in many use cases.

LLMs have way more parameters; more emergent abilities; require ridiculous amounts of resources; and have more powerful features than regular Language Models

Benefits of Transformers are dynamic computation (information is context-specific), good memory usage, parallelizability.

Transformer Architecture Components:
- Encoder-only architectures use representations for other tasks. Discriminative so model can give predictions for embeddings.
- Decoder-only Generative model predicting next word / future one word at a time.

\ Unsupervised Representation Learning: Given unlabeled data 
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

== DNA as language
- Full understanding of DNA isn't just nearby characters but functional annotation at many levels. Need to understand DNA at various granularities (protein language + codon language + regulatory DNA + RNA language models) all at once.

\ Mask Model Training: Mask a specific token in a word and train algorithm to predict that word.

== Building Foundation Models
Instead of creating a custom task-specific model, we can create a general-purpose trained model that is pre-trained, and then fine-tune for the task we want with shorter computation required.

\ K-mer Tokenization: Split sequence into sequence of kmers, which are then mapped to an index. 

Problem: K-mer size can grow exponentially, so instead we fine a new vocabulary based on training data via Byte-Pair Encoding. 

\ Byte-Pair Encoding: Start with characters. Repeatedly merge the most common pair of symbols into one. Do this until you hit a desired vocab size.

Once we have a BPE, given a new text, we start with a set of characters, and assign merge rules to reach our BPE tokenization.

== Applications

*DNABert:* Pre-Trained BERT for DNA sequences based on human references genome using overlapping k-mer tokenization. Goal: Wide-range applications (promoter region/transcriptional factor binding site/splite side prediction). To overcome input length limit of DNABERT, you replace positional embeddings with attention with linear biases, so if tokens are far apart, decrease bias to increase attention to nearby vectors.

*BarcodeBERT*: Pre-trained BERT for DNA sequences based on Barcode data using non-overlapping k-mer tokenization for taxonomic classification.

DNA transformer design choices: Overlapping Kmers tokens, Non-overlapped, Byte-pair encoding.

== Hyena Operators

To avoid the quadratic operation in tokens through Attention, they use Convolutions instead, in the Transformer-like-block. Transformers are $O(N^2)$ in time complexity, whereas convolutions are $O(N k)$ Training process was to take sample from human genome, and use next token prediction on single nucleotide tokens. Hyena operators are good for regulatory element classification (short scan) or chromatin profiling, and species classification (long scan).  

#image("../assets/hyena-operator.png")

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