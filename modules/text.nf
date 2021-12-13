params.scriptDir = "$baseDir/src"

workflow textRenamer {
  take:
    texts
    fileDictionary
  main:
    renameText(texts, fileDictionary)
  emit:
    renameText.out
}

process renameText {
  label 'renameText'
  publishDir "$params.output", mode: 'copy'
  input:
    tuple path(text), val(relPath), val(newPath), val(oldSample), val(newSample), val(oldSeqRun), val(newSeqRun)
    path fileDictionary
  output:
    path(newPath)
  script:
  """
  mkdir -p \$(dirname ${newPath})
  python ${params.scriptDir}/renameText.py ${text} ${fileDictionary} ${newPath}
  """
}
