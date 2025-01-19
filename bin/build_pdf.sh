#!/bin/bash

SVGDIR=$1
OUTPUTDIR=$SVGDIR/output
rm -rf $OUTPUTDIR
mkdir -p $OUTPUTDIR/png

i=0
rotate="-rotate 0" #portrait
# rotate="-rotate 270" #paysage
ls $SVGDIR/*.svg | while read file; do
  SVGFILE=$(echo -n $filegrep | sed 's|^.*/||');

  inkscape $file -h 484 -o $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).tmp.png
  convert $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).tmp.png -extent 1240x584-380-50 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 20,40 '$(printf "%02d" $(($i + 1)))'" -draw "line 0,0 0,30 line 0,50 0,80 line 0,0 30,0 line 50,0 80,0 line 0,583 30,583 line 50,583 80,583 line 0,583 0,553 line 0,543 0,513" $rotate $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).png
  rm $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).tmp.png

  i=$(($i + 1))

  #protrait
  if [ "$rotate" == "-rotate 0" ]
  then
    rotate="-rotate 180"
  else
    rotate="-rotate 0"
  fi

  #paysage
  # if [ "$rotate" == "-rotate 270" ]
  # then
  #   rotate="-rotate 90"
  # else
  #   rotate="-rotate 270"
  # fi
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
  convert -extent 2480x3508+0-2 $OUTPUTDIR/final_$(printf "%02d" $i).tmp.png -draw "line 1150,0 1150,50 line 1150,3263 1150,3213" $OUTPUTDIR/final_$(printf "%02d" $i).png
  rm $OUTPUTDIR/final_$(printf "%02d" $i).tmp.png;
done

ls $OUTPUTDIR/final_*.png | while read file; do
  convert -units PixelsPerInch -density 300 $file $file.pdf
done

pdftk $OUTPUTDIR/final_*.pdf cat output $OUTPUTDIR/final.pdf
