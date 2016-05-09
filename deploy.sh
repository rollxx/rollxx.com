#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
cd public
git checkout master
git remote add ssh git@github.com:rollxx/rollxx.github.io.git

git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

# Add changes to git.
git add -A :/

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1  ]
      then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push ssh master

# Come Back
cd ..
