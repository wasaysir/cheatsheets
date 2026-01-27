= Proteomics

Types of protein structure:
/ Primary: Amino Acid Sequence
/ Secondary: hydrogen bonding of peptide backbone (alpha helix, beta pleated sheets)
/ Tertiary: 3D folding due to side chain interactions
/ Quaternary: Multiple Amino Acid Chains

/ Residue: Amino acid in a peptide chain
/ Peptide: Chain of amino acids
/ Oligopeptide: 2-20 residues
/ Polypeptide: 20+ residues

== Main Problems
*Identification*: Determine which proteins are present in sample (from database)
*Sequencing*: Determine amino acid sequence without database
*Quantification*: determine expression level of protein under 2+ different conditions

== Mass Spectrometry

#image("../assets/mass_spectrometry.png")

Samples are ionized and then deflected by magnetic field. Final result on detector is dependent on mass-charge. Greater mass means smaller movement, greater charge means greater movement.

/ MS/MS (Tandem Mass Spectrometry): Two-stage mass spectrometry, that first separates protein by mass/charge ionization, and then fragments the proteins before running it through a mas spectrometry to analyze again. This seocnd stage is useful for understanding the composition of proteins.

Samples are detected by mass over charge. To differentiate between same ratios, proteins typically have multiple charge states, so you can identify proteins by the relative peaks of different charge mass/charge ratios.

#image("../assets/real_amino_acid_mass_table.png")

#image("../assets/integer_mass_table.png")

Note that we fragment peptides in MS, and derive the masses for each peptide chain to derive the entire sequence of the protein. For instance, given a peptide ANELLLNVK, we will fragment it into A, NELLLNVK, AN, ELLLNVK, ANE, LLLNVK, etc. We can then determine the peptide by daisy chaining in reverse. 

== MS Interpretations

2 ways to interpret MS/MS spectra: Search through existing protein databases or do de novo sequencing.

To search through the database, given a known protein sequence, use enzyme digestion rule to cut into peptides, and for each peptide compare with spectrum to see how well it matches the derived peptide fragments.

#image("../assets/manual-de-novo-sequencing.png")

#image("../assets/real-spectra-sequencing.png")

