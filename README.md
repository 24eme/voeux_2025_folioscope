# Voeux 2025

Scripts et template svg qui permettent de générer les pdf des vignettes et couvertures avec les traits de coupes pour imprimer les folioscopes des voeux du 24ème : https://24eme.fr/2025/

Tout le code est sous licence libre AGPL-3.0.

## Utilisation

Pour générer le PDF des vignettes d'un folioscope avec l'image de sa couverture :

```
# Usage : build_pdf_template.sh template(charlene,gabriel,jb,tangui,tanguy ou vincent) ligne1 ligne2 ligne3 Nom Organisme

bash bin/build_pdf_template.sh gabriel test "Bonne année 2025" "Test, nos meilleurs" "Voeux !" "Test" "24ème"

```

La liste des templates disponible se trouvent dans le dossier [template](https://github.com/24eme/voeux_2025_folioscope/tree/master/templates);

Les différents fichiers seront générés dans le dossier `output` à la racine du projet.

Pour générer plusieurs folioscope à l'aide d'un fichier csv avec des ';' comme séparateur :

```
# Sctructure d'une ligne du csv : Ligne1;Ligne2;Ligne3;Template;Nom;Organisme

cat /path/csvfile | sed 's/^*//' | awk -F ";" '{ gsub(/[ \t]+$/, "", $1); gsub(/[ \t]+$/, "", $2); gsub(/[ \t]+$/, "", $3); print "bash bin/build_pdf_template.sh " $4 " \"" $1 "\" \"" $2 "\" \"" $3 "\" \"" $5 "\" \"" $6 "\""}' | bash
```

Générer un pdf contenant tous les folioscopes et toutes les couvertures qui sont présents dans le dossier `output`


```
bash bin/compile.sh
```

Ce script génère un fichier output/sketchs.pdf et /output/couvertures.pdf

## Exemple

Générer un folioscope d'exemple pour chacun des templates existant :

```
ls templates | grep -v ".svg" | while read template; do bash bin/build_pdf_template.sh $template "Le 24ème vous" "souhaite une douce" "et belle année 2025 !" "example_$template" "24eme"; done
```

Ce script va générer 2 pdfs prêt à être imprimer :

- [Le pdf des vignettes](https://github.com/24eme/voeux_2025_folioscope/blob/master/example/sketchs.pdf)
- [Le pdf des couvertures](https://github.com/24eme/voeux_2025_folioscope/blob/master/example/couvertures.pdf)

Ainsi que les gifs animés de chaque template :

![Exemple du template charlene](https://raw.githubusercontent.com/24eme/voeux_2025_folioscope/refs/heads/master/example/gif/EXAMPLECHARLENE_24EME.gif)
![Exemple du template gabriel](https://raw.githubusercontent.com/24eme/voeux_2025_folioscope/refs/heads/master/example/gif/EXAMPLEGABRIEL_24EME.gif)
![Exemple du template jb](https://raw.githubusercontent.com/24eme/voeux_2025_folioscope/refs/heads/master/example/gif/EXAMPLEJB_24EME.gif)
![Exemple du template tangui](https://raw.githubusercontent.com/24eme/voeux_2025_folioscope/refs/heads/master/example/gif/EXAMPLETANGUI_24EME.gif)
![Exemple du template tanguy](https://raw.githubusercontent.com/24eme/voeux_2025_folioscope/refs/heads/master/example/gif/EXAMPLETANGUY_24EME.gif)
![Exemple du template vincent](https://raw.githubusercontent.com/24eme/voeux_2025_folioscope/refs/heads/master/example/gif/EXAMPLEVINCENT_24EME.gif)
