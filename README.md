# sample-renamer
Renames samples to use a new accession and run id in the file names as well as internally inside each file.

## Usage
    ./nextflow -log logs/nextflow.log run -w ./.work rename.nf --input ./input/input_folder --fileDictionary configs/defaultDict.json -resume

## Usage HaloPlex
    ./nextflow -log logs/nextflow.log run -w ./.work rename.nf --input ./input/HaloPlex --fileDictionary configs/haloplexDict.json -resume

## Usage - Archer FusionPlex
    ./nextflow -log logs/nextflow.log run -w ./.work rename.nf --input ./input/Archer --fileDictionary configs/archerDict.json -resume

## Supported Extensions
* txt
* tsv
* vcf
* bam
* bai
* bed
* CalculateHsMetrics
* DepthOfCoverage
* html

## Unsupported extensions
The following file extensions are copied without alteration from the input folder
* pdf
* idx

Other files are excluded from copying.