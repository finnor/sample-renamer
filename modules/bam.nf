workflow bamRenamer {
  take:
    bams
  main:
    renameBAM(bams)
  emit:
    outBam = renameBAM.out.outBam
    outBai = renameBAM.out.outBai
}

process renameBAM {
  label 'renameBAM'
  publishDir "$params.output", mode: 'copy'
  input:
    tuple path(bam), val(relPath), val(newPath), val(oldSample), val(newSample), val(oldSeqRun), val(newSeqRun)
  output:
    path(newPath), emit: outBam
    path("${newPath}.bai"), emit: outBai
  script:
  """
  mkdir -p \$(dirname ${newPath})
  samtools view -h --no-PG ${bam} | sed "s/${oldSample}/${newSample}/g" | sed "s/${oldSeqRun}/${newSeqRun}/g" | samtools view --no-PG -S -b > ${newPath}
  samtools index ${newPath} ${newPath}.bai
  """
}
