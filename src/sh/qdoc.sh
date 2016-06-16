#!/bin/bash
usage () {
cat << EOF
qdoc: generate HTML documentation for q files
usage: qdoc input_directory output_directory [pattern]

'pattern' is an optinoal regex that will be applied to 'find' when searcing
for files to document. The default is "*.q"

EOF
}

here=$(dirname $0)
input=$1
output=$2
pattern=$3
[[ -z $pattern ]] && pattern="*.q"

files=$(find $input -type f -name "$pattern")

rm -r $output/*

mkdir -p $output/css
mkdir -p $output/qdoc

for file in ${files[@]}; do
  q $here/../q/qdoc.q $file $output/qdoc -q
done

q $here/../q/qdocindex.q $output/qdoc $output -q

cp $here/../html/qdoc_index.html $output/index.html

cp $here/../css/qdoc.css $output/css/qdoc.css
