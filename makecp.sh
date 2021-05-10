# clean and rebuild pages
rm -r build/
make html

rm -r docs/
cp -r build/html/ docs/
touch docs/.nojekyll
