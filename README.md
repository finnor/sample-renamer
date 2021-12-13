# sample-renamer
Renames samples to use a new accession and run id in the file names as well as internally inside each file.

## Run Help
./nextflow run -w ./.work rename.nf --input ./input/input_folder --fileDictionary configs/defaultDict.json -resume

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
The following file extensions are copied with alteration from the input folder
* pdf
* idx

Other files are excluded from copying.