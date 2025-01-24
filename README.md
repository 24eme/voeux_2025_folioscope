# Voeux 2025

```
bash bin/build_pdf_template.sh gabriel test "Bonne année 2025" "Test, nos meilleurs" "Voeux !"

```

Compile depuis un csv :

```
cat /path/csvfile | sed 's/^*//' | awk -F ";" '{ gsub(/[ \t]+$/, "", $1); gsub(/[ \t]+$/, "", $2); gsub(/[ \t]+$/, "", $3); print "bash bin/build_pdf_template.sh " $4 " \"" $1 "\" \"" $2 "\" \"" $3 "\" \"" $5 "\" \"" $6 "\""}' | bash
```
