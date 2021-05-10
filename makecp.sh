# clean and rebuild pages
rm -r build/
make html

cp -ru build/html/* docs/
touch docs/.nojekyll
