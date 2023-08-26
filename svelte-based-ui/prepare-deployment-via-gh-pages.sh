# this is probably only necessary if you deploy via gh pages

sed -i'' -e 's/href="\//href=".\//g' ./dist/index.html
sed -i'' -e 's/src="\//src=".\//g' ./dist/index.html

cp -r ./dist ./../docs