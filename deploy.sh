#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

cd $SOURCE_DIR
git remote add ssh git@github.com:rollxx/rollxx.github.io.git
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

git add -A
msg="deploy $(date)"
if [ $# -eq 1 ]; then msg="$1"; fi
git diff --staged --quiet || git commit -m "$msg"
git push ssh $DEPLOY_BRANCH

cd ..

curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$cloudflare_zone/purge_cache" \
  -H "X-Auth-Email: $cloudflare_email" \
  -H "X-Auth-Key: $cloudflare_api_key" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'
