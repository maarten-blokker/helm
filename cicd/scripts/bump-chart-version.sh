#!/usr/bin/env bash

set -euo pipefail

parent_dir="$1"
update_type="$2"
app_version="$3"
chart_file="charts/${parent_dir}/Chart.yaml"
chart_version=$(grep "^version:" "$chart_file" | awk '{print $2}')

if [[ ! $chart_version ]]; then
  echo "No valid version was found"
  exit 1
fi

# Increment the chart version based on the update type
major=$(echo "$chart_version" | cut -d. -f1)
minor=$(echo "$chart_version" | cut -d. -f2)
patch=$(echo "$chart_version" | cut -d. -f3)

if [[ "$update_type" =~ (major|replacement) ]]; then
  major=$(( major + 1 ))
  minor=0
  patch=0
elif [[ "$update_type" =~ 'minor' ]]; then
  minor=$(( minor + 1 ))
  patch=0
else
  patch=$(( patch + 1 ))
fi

new_chart_version="${major}.${minor}.${patch}"

# Update the Helm chart file
echo "Bumping chart version for $parent_dir from $chart_version to $new_chart_version"
sed -i "s/^version:.*/version: ${new_chart_version}/g" "$chart_file"

if [[ -n "$app_version" ]]; then
  sed -i "s/^appVersion:.*/appVersion: ${app_version}/g" "$chart_file"
  echo "Updated appVersion to $app_version"
fi