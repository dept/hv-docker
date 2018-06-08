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
' > ./build/_headers


## Create Zip

FILE=netlify.zip
echo -e "📦  ${CYAN}Zipping all build files to $FILE${RESTORE}"
currentDirectory=$(pwd)
cd $source_directory; zip -rq ../$FILE .; cd $currentDirectory



echo -e "🚀  ${CYAN}Deploying to ${YELLOW}Netlify${RESTORE}"

## Create Site

curl -s -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN" -X POST -d "name=hv-$site_name&force_ssl=true" https://api.netlify.com/api/v1/sites


## Upload Zip, create deploy

# echo "Message:   $message"
# echo "Converted: ${message//\'/\\\'}"
# echo "JS:        encodeURIComponent('${message//\'/\\\'}')"
message_url_encoded=$(node -p "encodeURIComponent('${message//\'/\\\'}')")

curl -s -H "Content-Type: application/zip" -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN" --data-binary "@$FILE" https://api.netlify.com/api/v1/sites/hv-$site_name.netlify.com/deploys?title=$message_url_encoded > /tmp/netlify_deploy.json

cat /tmp/netlify_deploy.json | jq -r '.deploy_ssl_url' > $output
url=$(cat $output)

echo -e "\n\n"
echo -e "✅  ${GREEN}Successfully deployed to $url${RESTORE}"
echo -e "    Be aware that it might take a few minutes for the deployment to complete."
