#!/bin/bash

#Including .ini file
. config.ini

#dirs/files
WORK_DIR=$(pwd)
OUTPUT_FILENAME="$WORK_DIR""/""$OUTPUT_FILE"
HTML_DIR="$WORK_DIR""/html_data/"
HTML_HEAD="$HTML_DIR""head.html"
HTML_TAIL="$HTML_DIR""tail.html"

#html strings
HTML_TITLE="<h3>$PROJECT_TITLE</h3>$PROJECT_SUBTITLE<br><br>"
HTML_GROUP_HEAD="<br><b>"
HTML_GROUP_TAIL="</b><br>"
HTML_BUTTON_HEAD="<div onClick='drawer_toggle(this)' class='button'>"
HTML_BUTTON_BODY="</div><div class='drawer'>"
HTML_BUTTON_TAIL="</div>"

#apply color
HTML_HEAD_COLOR_STRING=$(cat $HTML_HEAD)


HTML_HEAD_COLOR_FIX=${HTML_HEAD_COLOR_STRING//PROJECT_COLOR_A/$BACK_COLOR}
HTML_HEAD_COLOR_CHANGED=${HTML_HEAD_COLOR_FIX//PROJECT_COLOR_B/$FRONT_COLOR}

#write html
echo "" > $OUTPUT_FILENAME
echo $HTML_HEAD_COLOR_CHANGED >> $OUTPUT_FILENAME
echo $HTML_TITLE >> $OUTPUT_FILENAME

#get text
cd ./note_data/ 
SUB_SECTIONS=$( find -path './*' -prune -type d | sed 's/ /\\ /g')

for GROUP in $SUB_SECTIONS
    #SUB_SECTIONS_FILES 
	do cd "$GROUP"
	SUB_SECTIONS_FILES=$( find -path './*' -prune -type f )
	FIX_GROUPNAME=$( echo "$GROUP" | cut -c 3- )
	echo $HTML_GROUP_HEAD >> $OUTPUT_FILENAME
	echo $FIX_GROUPNAME >> $OUTPUT_FILENAME
	echo $HTML_GROUP_TAIL >> $OUTPUT_FILENAME
	
	for FILE in $SUB_SECTIONS_FILES
		do
			FIX_FILENAME=$( echo "$FILE" | cut -c 3- )
			echo $HTML_BUTTON_HEAD >> $OUTPUT_FILENAME
			echo $FIX_FILENAME >> $OUTPUT_FILENAME
			echo $HTML_BUTTON_BODY >> $OUTPUT_FILENAME
			NOTE_STRING=$(cat $FILE)				
			NOTE_STRING=${NOTE_STRING//&/&amp;}
			NOTE_STRING=${NOTE_STRING//</&lt;}
			NOTE_STRING=${NOTE_STRING//>/&gt;}
			NOTE_STRING=${NOTE_STRING//'"'/&quot;}
			NOTE_STRING=${NOTE_STRING//$'\n'/<br />}	
	    	echo $NOTE_STRING >> "$OUTPUT_FILENAME"
			echo $HTML_BUTTON_TAIL >> $OUTPUT_FILENAME
	done
	cd ..
done 

#html tail
cat $HTML_TAIL >> $OUTPUT_FILENAME

#strip empty lines
#sed -i '/^$/d' $OUTPUT_FILENAME

