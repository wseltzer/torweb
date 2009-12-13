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
podir="`dirname $wmldir`/translation/projects/website"

# A lot of the wml files have custom tags. These tags have been defined
# in website/include/versions.wmi. Tags that people usually forget to close,
# as well as tags that are not defined in versions.wmi have been added.
# See: https://svn.torproject.org/svn/website/trunk/include/versions.wmi
customtag=`echo $(cat "$wmldir/include/versions.wmi" | awk '{ printf "<%s> " , $2 }' | sed 's/<>//g') "<svnsandbox> <svnwebsite> <input> <hr> <br> <img>"`

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
	# file has been translated.
	# Example: Use '-k 21' to set this number down to 21%.
	
	# The nice thing with po4a-translate is that it will only write
	# the translated document if 80% or more has been translated.
	# But it will delete the wml if less than 80% has been
	# translated. To avoid having our current, translated wml files
	# deleted, we first convert the po to a temp wml. If this file
	# was written, we'll rename it.

	# If $onedirup is equal to $lang, that means we do not have a
	# subdirectory. Also, we don't want to convert english po back
	# to english wml.
	if [ $onedirup == $lang ]
	then
		# The location of the english wml file
		english="$wmldir/en/$wmlfile"

		# If the current subdirectory is "zh_CN" use "zh-cn" instead
		if [ $subdir = "zh_CN" ]
		then
			po4a-translate -f wml -m "$english" -p "$file" -l "$wmldir/zh-cn/tmp-$wmlfile" --master-charset utf-8 -L utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

			# Check to see if the file was written
			if [ -e "$wmldir/zh-cn/tmp-$wmlfile" ]
			then
				mv "$wmldir/zh-cn/tmp-$wmlfile" "$wmldir/zh-cn/$wmlfile"
			fi
		fi
		
		# Convert everything else
		if ([ $subdir != "en" ] && [ $subdir != "zh_CN" ])
		then
			po4a-translate -f wml -m "$english" -p "$file" -l "$wmldir/$subdir/tmp-$wmlfile" --master-charset utf-8 -L utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

			# Check to see if the file was written
			if [ -e "$wmldir/$subdir/tmp-$wmlfile" ]
			then
				mv "$wmldir/$subdir/tmp-$wmlfile" "$wmldir/$subdir/$wmlfile"
			fi
		fi
	else
		# The location of the english wml file
		english="$wmldir/$subdir/en/$wmlfile"
		
		# If the current language is "zh_CN" use "zh-cn" instead
		if [ $lang = "zh_CN" ]
		then
			po4a-translate -f wml -m "$english" -p "$file" -l "$wmldir/$subdir/zh-cn/tmp-$wmlfile" --master-charset utf-8 -L utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

			# Check to see if the file was written
			if [ -e "$wmldir/$subdir/zh-cn/tmp-$wmlfile" ]
			then
				mv "$wmldir/$subdir/zh-cn/tmp-$wmlfile" "$wmldir/$subdir/zh-cn/$wmlfile"
			fi
		fi
		
		# Convert everything else
		if ([ $lang != "en" ] && [ $lang != "zh_CN" ])
		then
			po4a-translate -f wml -m "$english" -p "$file" -l "$wmldir/$subdir/$lang/tmp-$wmlfile" --master-charset utf-8 -L utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

			# Check to see if the file was written
			if [ -e "$wmldir/$subdir/$lang/tmp-$wmlfile" ]
			then
				mv "$wmldir/$subdir/$lang/tmp-$wmlfile" "$wmldir/$subdir/$lang/$wmlfile"
			fi
		fi
	fi
done
