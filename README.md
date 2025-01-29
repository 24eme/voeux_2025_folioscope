# Voeux 2025

Générer les PDF des pages d'un folioscope et l'image de sa couverture :

```
bash bin/build_pdf_template.sh gabriel test "Bonne année 2025" "Test, nos meilleurs" "Voeux !"

```

Les différents fichiers seront générés dans le dossier `output` à la racine du projet

Générer les pdf des pages et la couverture depuis un fichier csv avec des ';' comme séparateur :

```
cat /path/csvfile | sed 's/^*//' | awk -F ";" '{ gsub(/[ \t]+$/, "", $1); gsub(/[ \t]+$/, "", $2); gsub(/[ \t]+$/, "", $3); print "bash bin/build_pdf_template.sh " $4 " \"" $1 "\" \"" $2 "\" \"" $3 "\" \"" $5 "\" \"" $6 "\""}' | bash
```

Générer un pdf contenant tous les folioscopes et toutes les couvertures qui sont présents dans le dossier `output`


```
bash bin/compile.sh
```

Ce script génère un fichier output/sketchs.pdf et /output/couvertures.pdf
