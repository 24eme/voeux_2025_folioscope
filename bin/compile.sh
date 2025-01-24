#!/bin/bash

OUTPUTDIR=output
TMPDIR=/tmp/voeux_$(date +%Y%m%d%H%M%S)

mkdir -p $TMPDIR/pdf
mkdir -p $TMPDIR/pngplanche

# Compilation des couvertures

cp -r $OUTPUTDIR/couvertures $TMPDIR/png

NBVIGNETTE_PAR_PAGE=6

NBPDF=$(($(ls $TMPDIR/png/ | wc -l) / $NBVIGNETTE_PAR_PAGE))
if [ "$(($(ls $TMPDIR/png/ | wc -l) % $NBVIGNETTE_PAR_PAGE))" != "0" ]
then
  NBPDF=$(($NBPDF+1))
fi

for i in $(seq 1 $NBPDF)
do
  mkdir -p $TMPDIR/montage
  ls $TMPDIR/png | head -n 6 | while read file;
  do
    mv $TMPDIR/png/$file $TMPDIR/montage/$file
  done
  montage -geometry +0+0 -tile 1 $(ls $TMPDIR/montage/*.png) $TMPDIR/pngplanche/couvertures_$(printf "%02d" $i).tmp.png
  convert -extent 2480x3508+0-2 $TMPDIR/pngplanche/couvertures_$(printf "%02d" $i).tmp.png $TMPDIR/pngplanche/couvertures_$(printf "%02d" $i).png
  rm $TMPDIR/pngplanche/couvertures_$(printf "%02d" $i).tmp.png
  convert -units PixelsPerInch -density 300 $TMPDIR/pngplanche/couvertures_$(printf "%02d" $i).png $TMPDIR/pdf/couvertures_$(printf "%02d" $i).pdf
  rm -rf $TMPDIR/montage
done

pdftk $TMPDIR/pdf/*.pdf cat output $OUTPUTDIR/couvertures.pdf

# Compilation des sketchs

pdftk $OUTPUTDIR/sketchs/*.pdf cat output $OUTPUTDIR/sketchs.pdf
