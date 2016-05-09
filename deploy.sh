#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# prepare the directory with generated files
cd $SOURCE_DIR
git checkout --force $DEPLOY_BRANCH
git remote add ssh git@github.com:rollxx/rollxx.github.io.git
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"
cd ..

# Build the project.
hugo # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
cd $SOURCE_DIR

# Add changes to git.
git add -A :/

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1  ]
      then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push ssh $DEPLOY_BRANCH

cd ..

# cleanup claoudflare cache
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$cloudflare-zone/purge_cache" \
-H "X-Auth-Email: $cloudflare-email" \
-H "X-Auth-Key: $cloudflare-api-key" \
-H "Content-Type: application/json" \
--data '{"purge_everything":true}'
