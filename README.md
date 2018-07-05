# HV Frontend Prototype Deployment

We maintain docker images in this repository to make deployments of frontend prototypes as easy as a pancake. 
We currently have two images that both feature current stable Node JS (incl. Yarn). Another one comes with Ruby
support (for our Middleman based stacks).

Their main benefit is that they provide two very simple yet powerful commands:

## hv-publish

- zips the build directory and saves the zip into Bitbucket downloads (we might skip this in the future because save2repo should be enough)
- publishes the build directory to a webserver (we right now use Netlify for our hosting / publishing service)
- saves the deployment info to the hvify.com database (currently via restdb.io)

Arguments

| **-s or --source**      | Path to source directory (defaults to `./build`)
| **-n or --name**        | Name of website (defaults to Bitbucket repo slug)
| **-d or --destination** | `netlify` or `aws` (defaults to netlify)

## save2repo

Creates a new repository in Bitbucket if necessary, based on the current Bitbucket repository.
It's gonna be created in the same project as the current repo.
Its slug will be "{current repo slug}-build", its name will be "{current repo name} (Build)".

Arguments

| **-s or --source**      | Path to source directory (defaults to `./build`)
| **-p or --path**        | The bitbucket repository path (will only be considered if destination is not set). Default: `{BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}-build`
| **-d or --destination** | The destination repository url with credentials. Default: Based on current bitbucket repository, see path parameter.

# Deployment

Install Docker, then just execute ```./build.sh```