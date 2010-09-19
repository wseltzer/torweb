#!/bin/bash
#
# Author: Runa Sandvik, <runa.sandvik@gmail.com>
# Google Summer of Code 2009
# 
# This is Free Software (GPLv3)
# http://www.gnu.org/licenses/gpl-3.0.txt
#
# This script will convert all the translated po files back to wml
# files.
#
# For more information, see the HOWTO and README in
# translation/tools/gsoc09.
#

### start config ###

# Location of the wml files
wmldir="$PWD"

# Location of the po files,
podir="`dirname $wmldir`/translation/projects/website/po"

# A lot of the wml files have custom tags. These tags have been defined
# in website/include/versions.wmi. Tags that people usually forget to close,
# as well as tags that are not defined in versions.wmi have been added.
# See: https://svn.torproject.org/svn/website/trunk/include/versions.wmi
customtag=`echo $(cat "$wmldir/include/versions.wmi" | awk '{ printf "<%s> " , $2 }' | sed 's/<>//g') "<svnsandbox> <svnwebsite> <svnprojects> <input> <hr> <br> <img> <gitblob>"`

# We also need to use the nodefault option of po4a; space separated list
# of tags that the module should not try to set by default in any
# category. For now, we only need the input tag.
nodefault='<input>'

### end config ###

# Create a lockfile to make sure that only one instance of the script
# can run at any time.
LOCKFILE=po2wml.lock

if lockfile -! -l 60 -r 3 "$LOCKFILE"; 
then
	echo "unable to acquire lock" >2
	exit 1
fi

trap "rm -f '$PWD/$LOCKFILE'" exit

# Check if translation/projects/website exist, i.e. has been checked out
if [ ! -d $podir ]
then
	echo "Have you remembered to check out translation/projects/website?"
	exit 1
fi

# cd to the right directory so we can commit the files later
cd "$wmldir"

# We need to find the po files
po=`find $podir -regex '^'$podir'/.*/.*\.po' -type f`

# For every wml, update po
for file in $po ; do
	
	# Get the basename of the file we are dealing with
	pofile=`basename $file`

	# Strip the file for its original extension and the translation
	# priority, and add .wml
	wmlfile="`echo $pofile | cut -d . -f 2`.wml"	

	# Find out what directory the file is in.
	indir=`dirname $file`

	# We also need to know what one directory up is
	onedirup=`dirname $indir`

	# We need to find out what subdirectory we are in
	subdir=`dirname $file | sed "s#$onedirup/##"`

	# And which language we are dealing with
	lang=`dirname $indir | sed "s#$podir/##"`

	# Time to write the translated wml file.
	# The translated document is written if 80% or more of the po
	# file has been translated. Example: Use '-k 21' to set this
	# number down to 21%. Also, po4a-translate will only write the
	# translated document if 80% or more has been translated.
	# However, it will delete the wml if less than 80% has been
	# translated. To avoid having our current, translated wml files
	# deleted, convert the po to a temp wml first. If this file was
	# actually written, rename it to wml.

	# Convert translations to directories such as website/nb/.
	function nosubdir {
		# The location of the english wml file
		english="$wmldir/en/$wmlfile"

		# Convert the translated file. Note that po4a will write the file and then delete it if less than 80% has been translated
		po4a-translate -f wml -m "$english" -p "$file" -l "$wmldir/$subdir/$wmlfile" --master-charset utf-8 -L utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

		# Check to see if the file was written
                if [ -e "$wmldir/$subdir/$wmlfile" ]
		then
                        # Remove last three lines in file
			sed -i -e :a -e '$d;N;2,3ba' -e 'P;D' "$wmldir/$subdir/$wmlfile"

			# Include foot.wmi
			echo "#include <foot.wmi>" >> "$wmldir/$subdir/$wmlfile"

			# If the file is mirrors.wml, include mirrors-table.wmi
			if [ $wmlfile == "mirrors.wml" ]
			then
				sed -i 's/<!--PO4ASHARPBEGIN/#/' "$wmldir/$subdir/$wmlfile"
				sed -i 's/PO4ASHARPEND-->//' "$wmldir/$subdir/$wmlfile"
			fi
		fi
	}	

	# Convert translations to directories such as website/torbrowser/nb/.
	# Again, po4a will write the file and then delete it if less than 80% has been translated
	function subdir {
		# The location of the english wml file
                english="$wmldir/$subdir/en/$wmlfile"

		# Convert the files
		po4a-translate -f wml -m "$english" -p "$file" -l "$wmldir/$subdir/$lang/$wmlfile" --master-charset utf-8 -L utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

		# Check to see if the file was written
		if [ -e "$wmldir/$subdir/$lang/$wmlfile" ]
		then
			# Remove last three lines in file
			sed -i -e :a -e '$d;N;2,3ba' -e 'P;D' "$wmldir/$subdir/$lang/$wmlfile"

			# Include foot.wmi
			echo "#include <foot.wmi>" >> "$wmldir/$subdir/$lang/$wmlfile"
		fi
	}

	# If $onedirup is equal to $lang, that means we do not have a
	# subdirectory.
	if [ $onedirup == $lang ]
	then
		# If the current subdirectory is "zh_CN" use "zh-cn" instead
		if [ $subdir = "zh_CN" ]
		then
			subdir="zh-cn"
			nosubdir
		fi
		
		# If the current directory is "nb" use "no" instead
		if [ $subdir = "nb" ]
		then
			subdir="no"
			nosubdir
		fi

		# If the current directory is "sv" use "se" instead
		if [ $subdir = "sv" ]
		then
			subdir="se"
			nosubdir
		fi

		# Convert everything else
		if [[ $subdir != "en" && $subdir != "zh_CN" && $subdir != "nb" && $subdir != "sv" ]]
		then
			nosubdir
		fi
	else
		# If the current language is "zh_CN" use "zh-cn" instead
		if [ $lang = "zh_CN" ]
		then
			lang="zh-cn"
			subdir
		fi

		# If the current language is "nb" use "no" instead
		if [ $lang = "nb" ]
		then
			lang="no"
			subdir
		fi

		# If the current language is "sv" use "se" instead
		if [ $lang = "sv" ]
		then
			lang="se"
			subdir
		fi
		
		# Convert everything else
		if [[ $lang != "en" && $lang != "zh_CN" && $lang != "nb" && $lang != "sv" ]]
		then
			subdir
		fi
	fi
done
