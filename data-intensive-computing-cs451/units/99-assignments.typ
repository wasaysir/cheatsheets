== Assignment 1
Pairs vs Stripes
- Stripes are faster than pairs because you can use an in-mapper combiner to speed things up. You can't necessarily do that with pairs because you're operating on unique pairs of words, so in a single line there's nothing to map. 
  - There are fewer key-value pairs to send, and combiners can do more work, but it's a heavier object (not supported by Hadoop) and it's more computationally expensive (usually better for data intensive programs if it removes the shuffle) and there's a concern the map will fit in memory.

For PMI you require two passes, where one is the modified word count (counting number of lines containing token) and second pass for the cooccurrences of pairs/stripes. The two passes are to ensure total counts of both terms in the pair are available to the reducer.

PMI is used to generate semantic meaning, where greater positive numbers means perfect synonym, and greater negative numbers means perfect antonyms. Thi sis useful to generate word embeddings.