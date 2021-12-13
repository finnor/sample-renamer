import groovy.json.JsonSlurper

if (params.fileDictionary.startsWith("/")) {
  params.fileDictionaryPath = params.fileDictionary
} else {
  params.fileDictionaryPath = "$baseDir/$params.fileDictionary"
}

def jsonSlurper = new JsonSlurper()
// new File object from your JSON file
def ConfigFile = new File(params.fileDictionaryPath)
// load the text from the JSON
String ConfigJSON = ConfigFile.text
// create a dictionary object from the JSON text
def fileConfig = jsonSlurper.parseText(ConfigJSON)

nextflow.enable.dsl=2

def mapFileNames(file, inputDir, fileConfig) {
  path = file.getFileName().toString()
  relPath = new File(new File(inputDir).toURI().relativize(file.toUri()).toString())
  newPath = relPath.toString()

  filename = file.name.toString()

  fileMatch = filename
  newFileMatch = filename

  fileConfig["samples"].each {
    if (filename.startsWith(it["old"])) {
      fileMatch = it["old"]
      newFileMatch = it["new"]
    }
    newPath = newPath.replace(it["old"], it["new"])
  }

  newPath = newPath.replace(fileConfig["sequencerRunId"]["old"], fileConfig["sequencerRunId"]["new"])

  return tuple(file, relPath, newPath, fileMatch, newFileMatch, fileConfig["sequencerRunId"]["old"], fileConfig["sequencerRunId"]["new"])
}


files = Channel.fromPath(params.input + "/**.{txt,tsv,vcf,bam,bai,pdf,bed,CalculateHsMetrics,DepthOfCoverage,html,idx}")
  .map { mapFileNames(it, params.input, fileConfig) }
  .branch {
    text: it.get(0).name.endsWith(".txt") || it.get(0).name.endsWith(".tsv") || it.get(0).name.endsWith(".vcf") || it.get(0).name.endsWith(".bed") || it.get(0).name.endsWith(".CalculateHsMetrics") || it.get(0).name.endsWith(".DepthOfCoverage") || it.get(0).name.endsWith(".html")
    bam: it.get(0).name.endsWith(".bam")
    unnamable: it.get(0).name.endsWith(".pdf") || it.get(0).name.endsWith(".idx")
  }

include { bamRenamer } from ("$baseDir/modules/bam")
include { textRenamer } from ("$baseDir/modules/text")
include { copy }  from ("$baseDir/modules/copy")

workflow {
  bamRenamer(files.bam)
  textRenamer(files.text, params.fileDictionaryPath)
  copy(files.unnamable)
}