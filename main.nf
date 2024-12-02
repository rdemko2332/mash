#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//---------------------------------------------------------------
// Param Checking 
//---------------------------------------------------------------

if(params.inputDir) {
  fastas_qch = Channel.fromPath([params.inputDir + '/OG*.fasta'])
}
else {
  throw new Exception("Missing params.inputDir")
}

//--------------------------------------------------------------------------
// Includes
//--------------------------------------------------------------------------

include { mash } from './modules/mash.nf'

//--------------------------------------------------------------------------
// Main Workflow
//--------------------------------------------------------------------------

workflow {
    mash(fastas_qch)
}

