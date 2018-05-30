#!/bin/bash


##### CONSTANTS

RESTORE='\033[0m'

RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'


##### FUNCTIONS

usage()
{
    echo -e '
USAGE:

./aws-deploy.sh --source ./build --name project-123

'$PURPLE'
-s | --source path/to/source
'$CYAN'
    Website directory to upload. Default: ./build

'$PURPLE'
-n | --name site_name
'$CYAN'
    Site name. We will use this for the netlify.com subdomain.
    E.g. --name doublerainbow -- will create a website hv-doublerainbow.netlify.com

'$PURPLE'
-h | --help
'$CYAN'
    Prints this help.
'$RESTORE'
    '
}




##### ARGUMENTS

source_directory=./build
site_name=notset
message="No message"
output=/tmp/url.txt

while [ "$1" != "" ]; do
    case $1 in
        -s | --source )         shift
                                source_directory=$1
                                ;;
        -n | --name )           shift
                                site_name=$1
                                ;;
        -m | --message )        shift
                                message=$1
                                ;;
        -o | --output )         shift
                                output=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ $site_name = notset ]
then
	echo -e "${RED}Missing site name (argument --name).${RESTORE}"
	usage
	exit 1
fi


##### MAIN


echo '
/*
  Cache-Control: public, max-age=31536000
' > ./_headers


## Create Zip

FILE=${FILE:-$site_name--`date +%Y-%m-%d`.zip} # uses same naming like hv-publish to avoid double zipping
if [ ! -f $FILE ]
then
    echo -e "📦  ${CYAN}Zipping all build files to $FILE${RESTORE}"
    currentDirectory=$(pwd)
    cd $source_directory; zip -r ../$FILE .; cd $currentDirectory
else
    echo -e "📦  ${CYAN}Adding _header file (for Netlify) to $FILE${RESTORE}"
    zip -u $FILE _headers
fi



echo -e "➡🚀  ${CYAN}Deploying to ${YELLOW}Netlify${RESTORE}"

echo "Message:   $message"
echo "Converted: ${message//\'/\\\'}"
echo "JS:        encodeURIComponent('${message//\'/\\\'}')"
message_url_encoded=$(node -p "encodeURIComponent('${message//\'/\\\'}')")


## Create Site

curl -s -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN" -X POST -d "name=hv-$site_name&force_ssl=true" https://api.netlify.com/api/v1/sites


## Upload Zip, create deploy

curl -s -H "Content-Type: application/zip" -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN" --data-binary "@$FILE" https://api.netlify.com/api/v1/sites/hv-$site_name.netlify.com/deploys?title=$message_url_encoded > /tmp/netlify_deploy.json

cat /tmp/netlify_deploy.json | jq -r '.deploy_ssl_url' > $output

echo -e "✅  ${GREEN}Successfully deployed!${RESTORE}"
