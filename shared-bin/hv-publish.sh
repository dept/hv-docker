#!/bin/bash

RANDOM_WORD=`node -p 'var words = [
	"ace",
	"admirable",
	"agreeable",
	"baroque",
	"beaming",
	"beautiful",
	"boss",
	"bright",
	"brilliant",
	"bully",
	"capital",
	"choice",
	"classy",
	"commendable",
	"congenial",
	"crack",
	"dazzling",
	"deluxe",
	"elegant",
	"eminent",
	"excellent",
	"exceptional",
	"fab",
	"favorable",
	"firstclass",
	"first",
	"flamboyant",
	"glittering",
	"glowing",
	"gnarly",
	"gorgeous",
	"grand",
	"grandiose",
	"gratifying",
	"great",
	"honorable",
	"imposing",
	"impressive",
	"lavish",
	"magnificent",
	"magnifico",
	"marvelous",
	"neat",
	"nice",
	"ornate",
	"pleasing",
	"plush",
	"posh",
	"positive",
	"precious",
	"prime",
	"rad",
	"radiant",
	"rainbow",
	"refulgent",
	"reputable",
	"resplendent",
	"rich",
	"satisfactory",
	"satisfying",
	"select",
	"shipshape",
	"gold",
	"sound",
	"spanking",
	"splashy",
	"splendid",
	"splendiferous",
	"splendrous",
	"sterling",
	"stupendous",
	"sumptuous",
	"super",
	"superb",
	"superior",
	"swanky",
	"tiptop",
	"valuable",
	"welcome",
	"wonderful",
	"worthy"
]

words[Math.floor(Math.random() * words.length)];
'`

##### ARGUMENTS

source_directory=./build
site_name=$BITBUCKET_REPO_SLUG
destination=netlify

while [ "$1" != "" ]; do
    case $1 in
        -s | --source )         shift
                                source_directory=$1
                                ;;
        -n | --name )           shift
                                site_name=$1
                                ;;
        -d | --destination )    shift
                                destination=$1
                                ;;
        * )                     exit 1
    esac
    shift
done



COMMIT_SUBJECT=`git log -n 1 --pretty=format:%s $BITBUCKET_COMMIT`
COMMIT_DATE=`git log -n 1 --pretty=format:%cI $BITBUCKET_COMMIT`
FILE=$BITBUCKET_BRANCH--`date +%Y-%m-%d`.zip
DOMAIN=$site_name-$RANDOM_WORD-$BITBUCKET_BUILD_NUMBER


currentDirectory=$(pwd)
cd $source_directory; zip -r ../$FILE .; cd $currentDirectory
curl -X POST --user "${BB_AUTH_STRING}" "https://api.bitbucket.org/2.0/repositories/${BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}/downloads" --form files=@"$FILE"

echo '{
	"repo_slug": "'$BITBUCKET_REPO_SLUG'",
	"commit_hash": "'$BITBUCKET_COMMIT'",
	"commit_message": "'${COMMIT_SUBJECT//\"/\\\"}'",
	"commit_date": "'$COMMIT_DATE'",
	"branch": "'$BITBUCKET_BRANCH'",
	"build_number": "'$BITBUCKET_BUILD_NUMBER'"
}' > $source_directory/.deploy.json

output=/tmp/url.txt

if [ $destination == "aws" ]
then
	aws-deploy --source $source_directory --name $DOMAIN --output $output
else
	netlify-deploy --source $source_directory --name $site_name --output $output --message "${COMMIT_SUBJECT//\"/\\\"}"
fi

deploy_url=`cat $output`

node -p "JSON.stringify({url:'$deploy_url', commit: '$BITBUCKET_COMMIT', branch: '$BITBUCKET_BRANCH', project: '$BITBUCKET_REPO_SLUG', message: '${COMMIT_SUBJECT//\'/\\\'}', comitted_at: '$COMMIT_DATE'})" > body.json
curl -k -H "Content-Type: application/json" -H "x-apikey: $RESTDB_API_KEY" -X POST -d @body.json 'https://hvify-ed6c.restdb.io/rest/builds'

