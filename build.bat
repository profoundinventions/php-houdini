@echo off
call make html
@echo Copying docs...
@mkdir docs
cp -av _build/html/* docs/
touch docs/.nojekyll

