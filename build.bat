@echo off
call make html
@mkdir docs
cp -av _build/html/* docs/
touch docs/.nojekyll

