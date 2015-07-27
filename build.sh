#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
jekyll build

# cleanup and copy generated HTML site to `master' branch
rm -rf ../androcode-es.github.io.master
mkdir ../androcode-es.github.io.master
cp -R _site/* ../androcode-es.github.io.master

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
cd ../androcode-es.github.io.master
git init
git remote add origin https://${GH_TOKEN}@github.com/androcode-es/androcode-es.github.io.git

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
git config user.email "git@androcode.es"
git config user.name "Androcode"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1 