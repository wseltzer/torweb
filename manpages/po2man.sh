#!/bin/bash
#
# Author: Runa A. Sandvik, <runa.sandvik@gmail.com>
# For The Tor Project, Inc.
#
# This is Free Software (GPLv3)
# http://www.gnu.org/licenses/gpl-3.0.txt
#
# This script will convert translated po files back to manpages. Before
# running the script, checkout the translation directory from
# https://svn.torproject.org, and clone the tor repository from
# git.torproject.org.
#	

### Start config ###

# Location of the translated manpages
translated="$PWD"

# Location of the website directory
wml="`dirname $translated`"

# Location of the English manpages. Assuming that the git clone of the
# tor repository is relative to the website
mandir="`dirname $wml`/tor/doc"

# Location of the po files. Assuming that the translation directory is
# relative to the website
podir="`dirname $wml`/translation/projects/manpages/po"

### End config ###

# Find po files to convert
po=`find $podir -type f -name \*.1.po`

# For every po found, create and/or update the translated manpage.
for file in $po ; do

	# Validate input and write results to a log file
	validate_script="`dirname $wmldir`/translation/tools/validate.py"
	validate_log="`dirname $wmldir`/manpages-validate.log"
	python "$validate_script" -i "$file" -l "$validate_log"

	# Get the basename of the file we are dealing with
	pofile=`basename $file`

	# Strip the file for its original extension and add .txt
	manfile="${pofile%.*}.txt"

	# Figure out which language we are dealing with.
	lang=`dirname $file | sed "s#$podir/##"`

	# The translated document is written if 80% or more of the po
	# file has been translated. Also, po4a-translate will only write
	# the translated document if 80% or more has been translated.
	# However, it will delete the translated txt if less than 80%
	# has been translated. To avoid having our current, translated
	# txt files deleted, convert the po to a temp txt first. If this
	# file was actually written, rename it to txt.

	# Convert translated po files back to manpages.
	function convert {
		po4a-translate -f text -m "$mandir/$manfile" -p "$file"  -l "$translated/$lang/tmp-$manfile" --master-charset utf-8 -L utf-8

		# Check to see if the file was written. If yes, rename
		# it.
		if [ -e "$translated/$lang/tmp-$manfile" ]
		then
			mv "$translated/$lang/tmp-$manfile" "$translated/$lang/$manfile"

			# If tor.1.po has been translated, we need to
			# create tor-manual-dev.wml in the correct
			# language directory.
			if [ $manfile = "tor.1.txt" ]
			then
				if [ ! -e "$wml/docs/$lang/tor-manual-dev.wml" ]
				then

					if [ ! -d "$wml/docs/$lang/" ]
					then
						mkdir "$wml/docs/$lang/"
					fi

					# Copy template file for
					# tor-manual-dev.wml, and
					# replace "lang" with the
					# correct name of the language
					# directory.
					cp "$translated/en/tor-manual-dev.wml" "$wml/docs/$lang"
				       	sed -i "0,/lang/ s/lang/"$lang"/" "$wml/docs/$lang/tor-manual-dev.wml"	
				fi
			fi
		fi
	}

	# We have a few cases where the name of the language directory
	# in the translations module is not equal the name of the
	# language directory in the website module.

	# For "zh_CN" use "zh-cn" instead
	if [ $lang = "zh_CN" ]
	then
		lang="zh-cn"
		convert
	fi

	# For "nb" use "no" instead
	if [ $lang = "nb" ]
	then
		lang="no"
		convert
	fi

	# For "sv" use "se" instead
	if [ $lang = "sv" ]
	then
		lang="se"
		convert
	fi

	# Convert everything else
	if [[ $lang != "zh_CN" && $lang != "nb" && $lang != "sv" ]]
	then
		convert
	fi
done
