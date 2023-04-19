#!/bin/bash

git fetch --tags --depth=1000 --prune

if [ `git rev-parse --abbrev-ref HEAD` != "master" ]; then
    git branch --track master origin/master
fi

git-chglog -next-tag `autotag -n` -o CHANGELOG.md
git config user.name 'Jenkins CI'
git add CHANGELOG.md; git commit -m "Updated CHANGELOG"; git push --set-upstream origin master
autotag; git push origin --tags 
