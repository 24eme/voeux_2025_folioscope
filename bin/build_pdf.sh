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

  # large paysage
  #convert $file -extent 1272x450-472+0 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 20,225 '$(printf "%02d" $(($i + 1)))'" -draw "line 0,0 0,50 line 0,0 50,0 line 0,449 50,449 line 0,449 0,400" $rotate $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).png

  #large paysage carrée
  #convert $file -extent 1150x800-325-175 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 20,225 '$(printf "%02d" $(($i + 1)))'" -draw "line 0,0 0,30 line 0,50 0,80 line 0,0 30,0 line 50,0 80,0 line 0,799 50,799 line 0,799 0,749" $rotate $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).png

  #normal paysage carrée
  convert $file -extent 1150x544-325-46 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 20,50 '$(printf "%02d" $(($i + 1)))'" -draw "line 0,0 0,30 line 0,50 0,80 line 0,0 30,0 line 50,0 80,0 line 0,543 30,543 line 50,543 80,543 line 0,543 0,513 line 0,493 0,463" $rotate $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).png

  # small
  #convert $file -extent 900x450-100+0 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 20,225 '$(printf "%02d" $(($i + 1)))'" -draw "line 0,0 0,50 line 0,0 50,0 line 0,449 50,449 line 0,449 0,400" $rotate $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).png

  # large portrait
  # convert $file -extent 800x1150+0-700 -background white -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 400,40 '$(printf "%02d" $(($i + 1)))'" -draw "line 0,0 0,50 line 0,0 50,0 line 799,0 749,0 line 799,0 799,50 line 0,1149 10,1149 line 799,1149 789,1149" $rotate $OUTPUTDIR/png/$(printf "%02d" $(($i + 1))).png

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
  convert $OUTPUTDIR/final_$(printf "%02d" $i).tmp.png -draw "line 1150,0 1150,50 line 1150,3263 1150,3213" $OUTPUTDIR/final_$(printf "%02d" $i).png
  rm $OUTPUTDIR/final_$(printf "%02d" $i).tmp.png;
done

ls $OUTPUTDIR/final_*.png | while read file; do
  convert $file $file.pdf
done

pdftk $OUTPUTDIR/final_*.pdf cat output $OUTPUTDIR/final.pdf
