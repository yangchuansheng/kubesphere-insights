#!/bin/bash

[ -f "$GITHUB_ENV" ] && source $GITHUB_ENV

FROM_DATE=$(date -d'14 day ago' +%Y-%m-%d)
UNTIL_DATE=$(date +%Y-%m-%d)

for i in $(cat ks_repo.txt);
do
  for j in {1..30};
  do
      curl -s -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$i/commits?since=${FROM_DATE}T00:00:00Z&until=${UNTIL_DATE}T00:00:00Z&per_page=100&page=$j"|jq -r '.[].committer.login'|sort|uniq >> ks_all_contributors_within_two_weeks_source.txt
      curl -s -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$i/commits?since=${FROM_DATE}T00:00:00Z&until=${UNTIL_DATE}T00:00:00Z&per_page=100&page=$j"|jq -r '.[].author.login'|sort|uniq >> ks_all_contributors_within_two_weeks_source.txt
  done
done

cat ks_all_contributors_within_two_weeks_source.txt|grep -Ev "\-bot|\[bot\]|^null$"|sort|uniq > ks_all_contributors_within_two_weeks_${DATE}.txt
