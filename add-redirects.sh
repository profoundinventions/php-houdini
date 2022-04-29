#!/bin/sh

# Add redirects to new URL
files=$(find docs -maxdepth 1 -name '*.html')

redirect_html=$(cat redirect.html)
for file in $files
do
    basename=$(basename "$file")
    echo $basename
    echo "$redirect_html" | sed -e 's#php-houdini-tutorial/#php-houdini-tutorial/'"$basename"'#' |
        tee redirects/"$basename"
done
