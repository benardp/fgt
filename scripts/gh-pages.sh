#!/bin/bash
# Push doxygen documentation to `gh-pages`.
# Expects to be run from the top level directory.
#
# Inspired by travis-doxygen.sh from miloyip/rapidjson

set -e

skip() {
    echo "SKIPPING: $@" 1>&2
    echo "Exiting..."
    exit 0
}

abort() {
    echo "ERROR: $@" 1>&2
    echo "Exiting..."
    exit 1
}

[ -f scripts/gh-pages.sh ] || abort "scripts/gh-pages.sh must be run from PROJECT_SOURCE_DIR"

if [ "${TRAVIS}" = "true" ]; then
    [ "${TRAVIS_PULL_REQUEST}" = "false" ] || skip "Not building docs for pull requests"
    [ "${TRAVIS_BRANCH}" = "master" ] || skip "Only building docs for master branch"

    sudo apt-get install -y doxygen
fi

cd build/doc
rm -rf html
git clone -b gh-pages https://github.com/gadomski/fgt html
cd html
rm -rf .git/index
git clean -df
cd ../../..
doxygen build/Doxyfile
cd build/doc/html
git add --all
git diff-index --quiet HEAD || git commit -m "scripts/gh-pages.sh"

if [ "${TRAVIS}" = "true" ]; then
    git push "https://${GH_TOKEN}@github.com/gadomski/fgt.git" gh-pages
else
    git push git@github.com:gadomski/fgt gh-pages
fi
