# clean and rebuild pages
rm -r build/
make html

# switch branch and update pages
git switch gh-pages
rm -r docs/
cp -r build/html/ docs/
touch docs/.nojekyll

git add docs/
git commit -m 'Update GitHub Pages'
git push

# switch to source brance
git switch master
