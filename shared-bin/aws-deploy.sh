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
    Site name. We will use this to name the S3 bucket and for the hvify.net subdomain.
    E.g. --name doublerainbow -- will create a website doublerainbow.hvify.net

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

while [ "$1" != "" ]; do
    case $1 in
        -s | --source )         shift
                                source_directory=$1
                                ;;
        -n | --name )           shift
                                site_name=$1
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

export AWS_DEFAULT_REGION=us-east-1
export AWS_DEFAULT_OUTPUT=json


export TMP_BUCKET_REGION=$AWS_DEFAULT_REGION
export TMP_BUCKET_URL=http://$site_name.s3-website-$TMP_BUCKET_REGION.amazonaws.com/

aws configure set access_key $AWS_ACCESS_KEY_ID
aws configure set secret_key $AWS_SECRET_ACCESS_KEY
aws configure set region $AWS_DEFAULT_REGION
aws configure list





echo -e "📦  ${CYAN}Creating bucket ${YELLOW}$site_name${RESTORE}"

if [ $TMP_BUCKET_REGION = us-east-1 ]
then
	aws s3api create-bucket --bucket $site_name
else
	aws s3api create-bucket --bucket $site_name --create-bucket-configuration LocationConstraint=$TMP_BUCKET_REGION
fi

echo '{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Allow Public Access to All Objects",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::'$site_name'/*"
		}
	]
}' > /tmp/policy.json

echo '{
	"IndexDocument": {
		"Suffix": "index.html"
	},
	"ErrorDocument": {
		"Key": "404.html"
	},
	"RoutingRules": [
		{
			"Redirect": {
				"ReplaceKeyWith": "index.html"
			},
			"Condition": {
				"KeyPrefixEquals": "/"
			}
		}
	]
}' > /tmp/website.json

aws s3api put-bucket-policy --bucket $site_name --policy file:///tmp/policy.json
aws s3api put-bucket-website --bucket $site_name --website-configuration file:///tmp/website.json


echo -e "🚚  ${CYAN}Uploading ${YELLOW}$source_directory${CYAN} to bucket ${YELLOW}$site_name${RESTORE}"

aws s3 cp $source_directory s3://$site_name --recursive --include "*" --cache-control max-age=31536000,public --acl public-read 

# open $TMP_BUCKET_URL

echo -e "  -> A preview of your website is now available at ${YELLOW}$TMP_BUCKET_URL${RESTORE}"


# CLOUDFRONT

echo '{
	"CallerReference": "'$site_name'-'`date +%s`'",
	"Aliases": {
		"Quantity": 1,
        "Items": [
            "'$site_name'.hvify.net"
        ]
	},
	"DefaultRootObject": "index.html",
	"Origins": {
		"Quantity": 1,
		"Items": [
			{
				"Id": "S3-'$site_name'",
				"DomainName": "'$site_name'.s3.amazonaws.com",
				"S3OriginConfig": {
					"OriginAccessIdentity": ""
				}
			}
		]
	},
	"DefaultCacheBehavior": {
		"TargetOriginId": "S3-'$site_name'",
		"ForwardedValues": {
			"QueryString": false,
			"Cookies": {
				"Forward": "none"
			}
		},
		"TrustedSigners": {
			"Enabled": false,
			"Quantity": 0
		},
		"ViewerProtocolPolicy": "redirect-to-https",
		"MaxTTL": 31536000,
		"MinTTL": 86400,
		"DefaultTTL": 2500000,
		"Compress": true
	},
	"ViewerCertificate": {
	    "ACMCertificateArn": "'$AWS_SSL_CERTIFICATE'",
	    "Certificate": "'$AWS_SSL_CERTIFICATE'",
	    "SSLSupportMethod": "sni-only",
	    "MinimumProtocolVersion": "TLSv1.1_2016",
	    "CertificateSource": "acm"
	},
	"CacheBehaviors": {
		"Quantity": 0
	},
	"Comment": "",
	"Logging": {
		"Enabled": false,
		"IncludeCookies": false,
		"Bucket": "",
		"Prefix": ""
	},
	"PriceClass": "PriceClass_All",
	"Enabled": true
}' > /tmp/distconfig.json


echo -e "💊  ${CYAN}Pointing new cloudfront distribution to bucket ${YELLOW}$site_name${RESTORE}"

aws cloudfront create-distribution --distribution-config file:///tmp/distconfig.json > /tmp/distconfig_result.json

TMP_CLOUDFRONT_DNSNAME=`cat /tmp/distconfig_result.json | jq '.Distribution.DomainName'`





# ROUTE 53

echo '{
  "Comment": "",
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "'$site_name'.hvify.net",
        "Type": "A",
        "AliasTarget": {
            "HostedZoneId": "Z2FDTNDATAQYW2",
            "DNSName": '$TMP_CLOUDFRONT_DNSNAME',
            "EvaluateTargetHealth": false
        }
      }
    }
  ]
}' > /tmp/routeconfig.json

# more /tmp/routeconfig.json

echo -e "🚦  ${CYAN}Routing  ${YELLOW}$site_name.hvify.net${CYAN} to ${YELLOW}$TMP_CLOUDFRONT_DNSNAME${RESTORE}"

aws route53 change-resource-record-sets --hosted-zone-id $AWS_ROUTE_ZONE_ID --change-batch file:///tmp/routeconfig.json


echo -e "✅  ${GREEN}Successfully deployed! ${CYAN}Be aware that it takes approx. 10 min for Cloudfront to be ready.{RESTORE}"
