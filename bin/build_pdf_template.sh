#!/bin/bash

TEMPLATENAME=$1
SENTENCE_1=$2
SENTENCE_2=$3
SENTENCE_3=$4
DESTINATAIRE=$5
ORGANISME=$6

KEY="$(echo $DESTINATAIRE | sed -r 's/[^a-zA-Z0-9]*//g' | sed -r 's/^(.{15}).*$/\1/')_$(echo $ORGANISME | sed -r 's/[^a-zA-Z0-9]*//g' | sed -r 's/^(.{15}).*$/\1/')"
KEY=$(echo $KEY | tr [:lower:] [:upper:] | sed 's/[éèêëÉ]/E/g' | sed 's/[àầ]/A/g' | sed 's/[ûù]/U/g' | sed 's/[îï]/I/g' | sed 's/[ô]/O/g' | sed 's/ç/C/g')

SVGDIR=templates/$TEMPLATENAME
OUTPUTDIR=output
TMPDIR=/tmp/voeux_$(date +%Y%m%d%H%M%S)
UNIQUEIDENTIFIANT=$KEY

if test -f $OUTPUTDIR/sketchs/$UNIQUEIDENTIFIANT.pdf && test -f $OUTPUTDIR/couvertures/$UNIQUEIDENTIFIANT.png;
then
  exit;
fi

echo $KEY

mkdir -p $OUTPUTDIR/sketchs
mkdir -p $TMPDIR/png
mkdir -p $TMPDIR/pngcouvertures
mkdir -p $TMPDIR/svg
mkdir -p $TMPDIR/couv

convert -pointsize 30 -background transparent -font FreeMono -gravity center -fill black label:"$KEY" -rotate -90 -trim +repage $TMPDIR/key.png

i=0
rotate="-rotate 180" #portrait
ls $SVGDIR/*.svg | while read file; do
  SVGFILE=$(echo -n $file | sed 's|^.*/||');
  sed "s/%s1%/$SENTENCE_1/" $file | sed "s/%s2%/$SENTENCE_2/" | sed "s/%s3%/$SENTENCE_3/" > $TMPDIR/svg/$SVGFILE
  inkscape $TMPDIR/svg/$SVGFILE -h 484 -o $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.png 2> /dev/null
  convert $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.png -extent 1240x584-380-50 -background white -page +70+75 $TMPDIR/key.png -flatten $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.tmp.png
  convert $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.tmp.png -font FreeMono -pointsize 30 -draw "fill 'RGB(0,0,0)' text 60,50 '$(printf "%02d" $(($i + 1)))'" -draw "line 30,0 30,50 line 30,80 30,130 line 30,0 80,0 line 110,0 160,0 line 30,583 80,583 line 110,583 160,583 line 30,583 30,533 line 30,503 30,453" $rotate $TMPDIR/png/$(printf "%02d" $(($i + 1))).png
  rm $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.png
  rm $TMPDIR/png/$(printf "%02d" $(($i + 1))).tmp.tmp.png

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

cp $TMPDIR/final.pdf $OUTPUTDIR/sketchs/$UNIQUEIDENTIFIANT.pdf

sed "s/%destinataire%/$DESTINATAIRE/" templates/couverture.svg > $TMPDIR/couv/$UNIQUEIDENTIFIANT.svg
inkscape $TMPDIR/couv/$UNIQUEIDENTIFIANT.svg -o $TMPDIR/couv/$UNIQUEIDENTIFIANT.png

cp $TMPDIR/couv/$UNIQUEIDENTIFIANT.png $OUTPUTDIR/couvertures/$UNIQUEIDENTIFIANT.png

rm -rf  $TMPDIR
