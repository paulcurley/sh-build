#!/bin/bash

#delivery script to extract from svn and package the files up
#dependancies....
# nodejs/ npm - node.js
# uglifyjs - github.com/mishoo/UglifyJS


BUILDFROMLOCAL=false

DESTINATION="/var/www" #server destination
WEBSOURCE="https://svn" #location of online repo
SOURCE="$HOME/codebase_location/" #location of your working copy
TARGET="$HOME/extract_location" #where you save the file
TARFILENAME="delivery_code.tgz" #compressed file name


echo "mkdirectory"
mkdir $TARGET

#CHOOSE WHERE WE ARE GETING THE REPO FROM LOCAL/ OR FROM THE INTERNETZ
if $BUILDFROMLOCAL ; then
	echo "exporting from local repo"
	for x in `ls $SOURCE`
	do
		echo $SOURCE$x
	    if [ $SOURCE$x ]; then
	        svn update $SOURCE$x #update local copy
	        svn export --force $SOURCE$x $TARGET$x #export the bugger
	    fi
	done
else
	echo "EXPORTING FROM WEB"
	svn export --force $WEBSOURCE $TARGET #export the bugger
fi

#lets remove build files
rm "$TARGET/build.sh"



#compress the js
FILES="$TARGET/js/*.js"
for f in $FILES
do
  echo " uglifyjs -o ${f%%js}min.js $f  "
  uglifyjs -o ${f%%js}min.js $f
done




# compress the files
cd "$HOME/Desktop/"
tar cvzf $TARFILENAME "delivery_code"
echo "tar cvzf $TARFILENAME $TARGET"


#TIDY UP
#rm -r $TARGET


echo "done"