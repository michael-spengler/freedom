# this is probably only necessary if you deploy via gh pages

sed -i'' -e 's/href="\//href=".\//g' ./dist/index.html
sed -i'' -e 's/src="\//src=".\//g' ./dist/index.html
sed -i'' -e 's/crossorigin//g' ./dist/index.html

rm -rf ./../docs
cp -r ./dist ./../docs