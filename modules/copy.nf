params.scriptDir = "$baseDir/src"

workflow copy {
  take:
    filepath
  main:
    copyFile(filepath)
  emit:
    copyFile.out
}

process copyFile {
  publishDir "$params.output", mode: 'copy'
  input:
    tuple path(file), val(relPath), val(newPath), val(oldSample), val(newSample), val(oldSeqRun), val(newSeqRun)
  output:
    path(newPath)
  script:
  """
  mkdir -p \$(dirname ${newPath})
  mv ${file} ${newPath}
  """
}
