#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process runMash {
  publishDir params.outputDir, mode: 'copy'

  input:
    path fasta
    path bestRep

  output:
    path "*.mash"

  script:
   """
   perl /usr/bin/runMash.pl --inputDir . --bestRepFasta $bestRep
   """
}

workflow mash {
  take:
    seqs

  main:
    runMash(seqs, params.bestRepFile)
}