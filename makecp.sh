# clean and rebuild pages
rm -r build/
make html

cp -r build/html/* docs/
touch docs/.nojekyll
