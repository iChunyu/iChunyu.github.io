# clean and rebuild pages
rm -r build/
make html

# switch branch and update pages
git switch gh-pages
cp -rn build/html/ docs/
git add .
git commit -m 'Update GitHub Pages'
git push

# switch to source brance
git switch master
