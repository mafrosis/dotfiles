#! /bin/bash
set -e

USAGE='mysql-dump [-h] -d database -t tablename [-H host] [-u user] [-o outputdir]
  - you will be prompted for a password
  - username defaults to root
  - outputdir defaults to /tmp
'

usage() {
	echo -ne "$USAGE"
	exit 1
}

# liberally lifted from http://stackoverflow.com/a/8950118/425050

DBNAME=''
TABLE=''
HOST='localhost'
USER=''
OUTPUT=''

while getopts "hd:t:H:u:o:" options
do
	case $options in
		d ) DBNAME="$OPTARG";;
		t ) TABLE="$OPTARG";;
		H ) HOST="$OPTARG";;
		u ) USER="$OPTARG";;
		o ) OUTPUT="$OPTARG";;
		h ) usage;;
		\? ) usage;;
		* ) usage;;
	esac
done
shift $((OPTIND-1))

# check parameters
if [[ -z $DBNAME ]] || [[ -z $TABLE ]]; then
	usage
fi 

if [[ -z $USER ]]; then
	USER='root'
	echo 'Defaulting to user root'
fi

# default the output file name to /tmp
if [[ -z $OUTPUT ]]; then
	OUTPUT="/tmp/"$DBNAME"-"$TABLE"-$(date +%Y-%m-%d).csv"
fi

# create empty file and sets up column names using the information_schema
mysql -u "$USER" -p $DBNAME -B -e "SELECT COLUMN_NAME FROM information_schema.COLUMNS C WHERE table_name = '$TABLE';" | awk '{print $1}' | grep -iv ^COLUMN_NAME$ | sed 's/^/"/g;s/$/"/g' | tr '\n' ',' > $OUTPUT

# append newline to mark beginning of data vs. column titles
echo "" >> $OUTPUT

# dump data from DB into /tmp
mysqldump -t "-T/tmp" -u $USER -p $DBNAME $TABLE --fields-terminated-by=','

# merge data file and file w/ column names
cat "/tmp/$TABLE.txt" >> $OUTPUT

# delete tempfile
rm -f "/tmp/$TABLE.txt"

echo "File written to $OUTPUT"
