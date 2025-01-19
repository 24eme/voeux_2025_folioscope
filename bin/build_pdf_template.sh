#!/bin/bash

TEMPLATENAME=$1
UNIQUEIDENTIFIANT=$2
SENTENCE_1=$3
SENTENCE_2=$4
SENTENCE_3=$5

SVGDIR=templates/$TEMPLATENAME
OUTPUTDIR=output/verso
TMPDIR=/tmp/voeux_$(date +%Y%m%d%H%M%S)

mkdir -p $OUTPUTDIR
mkdir -p $TMPDIR/png
mkdir -p $TMPDIR/svg

i=0
rotate="-rotate 180" #portrait
ls $SVGDIR/*.svg | while read file; do
  SVGFILE=$(echo -n $file | sed 's|^.*/||');
  sed "s/%s1%/$SENTENCE_1/" $file | sed "s/%s2%/$SENTENCE_2/" | sed "s/%s3%/$SENTENCE_3/" > $TMPDIR/svg/$SVGFILE
  inkscape $TMPDIR/svg/$SVGFILE -h 484 -o $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.png
  convert $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.png -extent 1240x584-380-50 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 40,40 '$(printf "%02d" $(($i + 1)))'" -draw "line 20,0 20,50 line 20,80 20,130 line 20,0 70,0 line 100,0 150,0 line 20,583 70,583 line 100,583 150,583 line 20,583 20,533 line 20,503 20,453" $rotate $TMPDIR/png/$(printf "%02d" $(($i + 1))).png
  rm $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.png

  i=$(($i + 1))

  if [ "$rotate" == "-rotate 0" ]
  then
    rotate="-rotate 180"
  else
    rotate="-rotate 0"
  fi
done;

NBVIGNETTE_PAR_PAGE=12

NBPDF=$(($(ls $TMPDIR/png/ | wc -l) / $NBVIGNETTE_PAR_PAGE))
if [ "$(($(ls $TMPDIR/png/ | wc -l) % $NBVIGNETTE_PAR_PAGE))" != "0" ]
then
  NBPDF=$(($NBPDF+1))
fi

for i in $(seq 1 $NBPDF)
do
  montage -geometry +0+0 -tile 2 $(ls $TMPDIR/png/*.png | head -n $(($i*$NBVIGNETTE_PAR_PAGE)) | tail -n $NBVIGNETTE_PAR_PAGE) $TMPDIR/final_$(printf "%02d" $i).tmp.png
  convert -extent 2480x3508+0-2 $TMPDIR/final_$(printf "%02d" $i).tmp.png $TMPDIR/final_$(printf "%02d" $i).png
  rm $TMPDIR/final_$(printf "%02d" $i).tmp.png;
done

ls $TMPDIR/final_*.png | while read file; do
  convert -units PixelsPerInch -density 300 $file $file.pdf
done

pdftk $TMPDIR/final_*.pdf cat output $TMPDIR/final.pdf

cp $TMPDIR/final.pdf $OUTPUTDIR/$UNIQUEIDENTIFIANT.pdf
rm -rf  $TMPDIR

pdftk $OUTPUTDIR/*.pdf cat output $OUTPUTDIR/../verso.pdf
