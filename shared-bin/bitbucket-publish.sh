#!/bin/bash

COMMIT_SUBJECT=`git log -n 1 --pretty=format:%s $BITBUCKET_COMMIT`
FILE=$BITBUCKET_BRANCH--`date +%Y-%m-%d`.zip
DOMAIN=$BITBUCKET_REPO_SLUG-$BITBUCKET_BUILD_NUMBER

cd build; zip -r ../$FILE .; cd ..
curl -X POST --user "${BB_AUTH_STRING}" "https://api.bitbucket.org/2.0/repositories/${BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}/downloads" --form files=@"$FILE"

aws-deploy --source ./build --name $DOMAIN

node -p "JSON.stringify({url:'https://$DOMAIN.hvify.net', commit: '$BITBUCKET_COMMIT', branch: '$BITBUCKET_BRANCH', project: '$BITBUCKET_REPO_SLUG', message: '$COMMIT_SUBJECT'})" > body.json
curl -k -H "Content-Type: application/json" -H "x-apikey: $RESTDB_API_KEY" -X POST -d @body.json 'https://hvify-ed6c.restdb.io/rest/builds'

