
import argparse
import json
import os

parser = argparse.ArgumentParser(description='Renames identifiers inside text files')
parser.add_argument('text_file', help='Text file')
parser.add_argument('file_dictionary_file_path', help='JSON file mapping old identifiers to new identifiers')
parser.add_argument('output_file', help='Output file')
args = parser.parse_args()
textFile = args.text_file
fileDictionaryFilePath = args.file_dictionary_file_path
outputFile = args.output_file


with open(fileDictionaryFilePath) as fileDictionaryFile:
  fileDictionary = json.load(fileDictionaryFile)

outLines = []
with open(textFile, "r") as text:
  lines = text.readlines()
  for line in lines:
    for sample in fileDictionary["samples"]:
      line = line.replace(sample["old"], sample["new"])

    oldSeqRun = fileDictionary["sequencerRunId"]["old"]
    newSeqRun = fileDictionary["sequencerRunId"]["new"]
    line = line.replace(oldSeqRun, newSeqRun)
    outLines.append(line)

with open(outputFile, "w") as outFile:
  for line in outLines:
    outFile.write(line)
