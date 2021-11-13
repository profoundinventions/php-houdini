#!/usr/bin/env bash
make html &&
    (cd _build/html/* && rm -rf *) && 
    mkdir -p docs &&
    cp -av _build/html/* docs/ &&
    touch docs/.nojekyll

