#!/bin/bash
#
# Author: Runa Sandvik, <runa.sandvik@gmail.com>
# Google Summer of Code 2009
#
# This is Free Software (GPLv3)
# http://www.gnu.org/licenses/gpl-3.0.txt
#
# This script will convert all of the english wml files to po files, and
# keep them updated. The script will also convert subdirectories that
# exist in the english website module.
#
# For more information, see the HOWTO and README in
# translation/tools/gsoc09.
# 

### start config ###

# Location of the wml files
wmldir="$PWD"

# Location of the po files.
# Assuming that the translation directory is relative to the website
podir="`dirname $wmldir`/translation/projects/website"

# Set the copyright holder of the po files,
# for example "The Tor Project, Inc"
copyright="The Tor Project, Inc"

# A lot of the wml files have custom tags. These tags have been defined
# in website/include/versions.wmi. Tags that people usually forget to close,
# as well as tags that are not defined in versions.wmi have been added.
# See: https://svn.torproject.org/svn/website/trunk/include/versions.wmi
customtag=`echo $(cat "$wmldir/include/versions.wmi" | awk '{ printf "<%s> " , $2 }' | sed 's/<>//g') "<svnsandbox> <svnwebsite> <input> <hr> <br> <img>"`

# We also need to use the nodefault option of po4a; space separated list
# of tags that the module should not try to set by default in any
# category. For now, we only need the input tag.
nodefault='<input>'

# The script can write the name of unprocessed files to a log.
# If you want to enable this option, set the logfile here.
logfile=""

# This is the temp logfile. Leave this line even if you don't want to
# log. This will be deleted when the script is done.
tmplog="`dirname $wmldir`/tmp.log"

### end config ###

# Create a lockfile to make sure that only one instance of the script
# can run at any time.
LOCKFILE=wml2po.lock

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

# If the logfile is set, write the date.
if [ $logfile ]
then
	echo `date` > $logfile
fi

# Create the temp log
touch $tmplog

# We need to find out which language directories we have.
# We also need to excluse the website module directory itself, as well
# as .svn
langdir=`find "$podir" -maxdepth 1 -type d ! -path "$podir" ! -path "$podir/templates" ! -path "*\.*" | sed "s#$podir/##"`

# We only need the english wml files, but we do not wish to translate
# the eff documents.
wml=`find $wmldir -regex '^'$wmldir'/.*en/.*\.wml' -type f | grep -v '^'$wmldir'/eff'`

# For every language directory, create and/or update the po files.
for lang in $langdir ; do

	# For every english wml, see if the po needs to be created or
	# updated
	for file in $wml ; do

		# Get the basename of the file we are dealing with
		wmlfile=`basename $file`

		# Get the translation priority
		priority=`cat $file | grep "# Translation-Priority" | awk '{print $3}'`

		# If the file doesn't have a translation-priority, we can assume
		# that it doesn't need to be translated. Skip this file and
		# continue on with the next.
		if [ ! $priority ]
		then
			continue
		fi

		# Strip the file for its original extension and add .po
		pofile="$priority.${wmlfile%%.*}.po"

		# Find out what directory the file is in.
		# Also, remove the parth of the path that is $wmldir
		indir=`dirname $file`
	
		# We need to know what one dir up is
		onedirup=`dirname $indir | sed "s#$wmldir/##"`

		# We need to have the correct, full path to the po
		# directory for the file we are working on.
		# Also, did the subdirectory exist prior to running this
		# script? If not, create it now and add it to the
		# repository.
		if [ $onedirup = $wmldir ]
		then
			popath="$podir/$lang"
		else

			# We need to know if a subdirectory, such as torbutton,
			# exist in the translation module. If it does not exist,
			# the script will create it in all the directories under
			# translation/projects/website (excluding .svn)
			subdir=`find "$podir/$lang" -maxdepth 1 -type d	! -path "$ppodir/$lang" ! -path "*\.*"`

			for dir in $subdir ; do
				if [ ! -d "$podir/$lang/$onedirup" ]
				then
					svn mkdir "$podir/$lang/$onedirup"
				fi
			done

			# Set the path
			popath="$podir/$lang/$onedirup"

		fi
		
		# Check to see if the po existed prior to running this
		# script. If it didn't, check if there any files with the same
		# filename, but different priority. If neither of the files
		# exist, create with po4a-gettextize.
		if [ -e "$popath/$pofile" ]
		then
			poexist=1
		elif [ `find $popath -type f -name "*.$filename" | wc -l` -gt "0" ]
		then
			poexist=2

		# We need to rename the other file
		for file in `find $popath -type f -name "*.$filename"` ; do
			svn mv "$file" "$popath/$pofile"
			echo "$popath/$pofile" > $tmplog
		done
	
		else
			poexist=0
		fi

		# If the po file does not exist, convert it with
		# po4a-gettextize, set the right encoding and charset
		# and the correct copyright.
		if [ $poexist = 0 ]
		then
			# Convert it
			po4a-gettextize -f wml -m "$file" -p "$popath/$pofile" --master-charset utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

			# Check to see if the file exists
			if [ -e "$popath/$pofile" ]
			then
				# We don't want files without
				# content, so check the file first.
				content=`cat "$popath/$pofile" | grep '^#[.]' | wc -l`

				# If the file does not have any
				# content, delete it.
				if [ $content = 0 ] 
				then
					rm -f "$popath/$pofile"
					echo "$popath/$pofile" > $tmplog
				else
					# Set the right encoding and charset, as well
					# as the correct copyright holder.
					sed -i '0,/ENCODING/ s/ENCODING/8bit/' "$popath/$pofile"
					sed -i '0,/CHARSET/ s/CHARSET/utf-8/' "$popath/$pofile"
					sed -i "0,/Free Software Foundation, Inc/ s/Free Software Foundation, Inc/$copyright/" "$popath/$pofile"
				
					# And add it to the repository
					svn add "$popath/$pofile"
					echo "$popath/$pofile" > $tmplog
				fi
			fi

			# Update the file with po4a-updatepo to make the
			# word wrapping perfect
			po4a-updatepo -f wml -m "$file" -p "$popath/$pofile" --master-charset utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

			# Delete the backup
			rm -f "$popath/$pofile~"
		fi
		
		# If the po file does exist, calculate the hash first,
		# then update the file, then calculate the hash again.
		if [ $poexist = 1 ]
		then
			# Calculate the hash before we update the file
			before=`grep -vE '^("POT-Creation-Date:|#)' "$popath/$pofile" | md5sum | cut -d " " -f1`

			# Update the po file
			po4a-updatepo -f wml -m "$file" -p "$popath/$pofile" --master-charset utf-8 -o customtag="$customtag" -o nodefault="$nodefault"

			# Calculate the new hash
			after=`grep -vE '^("POT-Creation-Date:|#)' "$popath/$pofile" | md5sum | cut -d " " -f1`

			# Delete the backup
			rm -f "$popath/$pofile~"

			# Now we need to compare the before and after
			# hash. If they match (i.e. nothing has
			# changed), revert the file.
			if [ $before = $after ]
			then
				svn revert "$popath/$pofile"
				echo "$popath/$pofile" > $tmplog
			else
				echo "$popath/$pofile" > $tmplog
			fi
		fi

		# If a file with the same name but different priority
		# exist, then rename the file (we have done so already)
		# and update it with po4a-updatepo to make sure
		# everything else is ok.
		if [ $poexist = 2 ]
		then
			# Update the file
			po4a-updatepo -f wml -m "$file" -p "$popath/$pofile" --master-charset utf-8 -o customtag="$customtag" -o nodefault="$nodefault"
		fi
	
		# Write to the logfile
		if [ -e $logfile ]
		then
			if [ `cat $tmplog | grep "$popath/$pofile" | wc -l` -eq "0" ]
			then
				echo "could not process: " "$file" >> $logfile
			fi
		fi

		# Delete the temp log
		rm -f $tmplog
	done
done
