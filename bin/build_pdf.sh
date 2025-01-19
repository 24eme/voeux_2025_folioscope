#!/bin/bash

SVGDIR=$1
OUTPUTDIR=$SVGDIR/output
rm -rf $OUTPUTDIR
mkdir -p $OUTPUTDIR/png

i=0
rotate="-rotate 180" #portrait
ls $SVGDIR/*.svg | while read file; do
  SVGFILE=$(echo -n $filegrep | sed 's|^.*/||');

  inkscape $file -h 484 -o $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).tmp.png
  convert $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).tmp.png -extent 1240x584-380-50 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 40,40 '$(printf "%02d" $(($i + 1)))'" -draw "line 20,0 20,50 line 20,80 20,130 line 20,0 70,0 line 100,0 150,0 line 20,583 70,583 line 100,583 150,583 line 20,583 20,533 line 20,503 20,453" $rotate $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).png
  rm $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).tmp.png

  i=$(($i + 1))

  if [ "$rotate" == "-rotate 0" ]
  then
    rotate="-rotate 180"
  else
    rotate="-rotate 0"
  fi
done;

NBVIGNETTE_PAR_PAGE=12

NBPDF=$(($(ls $OUTPUTDIR/png/ | wc -l) / $NBVIGNETTE_PAR_PAGE))

if ! test $(($(ls $OUTPUTDIR/png/ | wc -l) % $NBVIGNETTE_PAR_PAGE)) > 0
then
  NBPDF=$(($NBPDF+1))
fi

for i in $(seq 1 $NBPDF)
do
  montage -geometry +0+0 -tile 2 $(ls $OUTPUTDIR/png/*.png | head -n $(($i*$NBVIGNETTE_PAR_PAGE)) | tail -n $NBVIGNETTE_PAR_PAGE) $OUTPUTDIR/final_$(printf "%02d" $i).tmp.png
  convert -extent 2480x3508+0-2 $OUTPUTDIR/final_$(printf "%02d" $i).tmp.png $OUTPUTDIR/final_$(printf "%02d" $i).png
  rm $OUTPUTDIR/final_$(printf "%02d" $i).tmp.png;
done

rm -rf $OUTPUTDIR/png

ls $OUTPUTDIR/final_*.png | while read file; do
  convert -units PixelsPerInch -density 300 $file $file.pdf
  rm $file;
done

pdftk $OUTPUTDIR/final_*.pdf cat output $OUTPUTDIR/final.pdf

rm -rf  $OUTPUTDIR/final_*.pdf
