#!/bin/bash

if [ $# -lt 1 ]; then
    echo "you must provide atleast one git repository to clone"
    exit 1
fi

export AZURE_STORAGE_ACCOUNT=bitbucketdrstorage
export AZURE_STORAGE_KEY=lyzJSosJIv1JRVNtDmbINdmcedy9XW8KJZ+b8sbFptZ9VMOgp7xHVVPOd18ani1R639NYkjGMCSSRvH0Z8TeZg==

for repo in "$@"
do
    echo "Cloning git repository $repo"

    git clone https://github.com/adaraz-demo/"$repo".git

    cd ./"$repo"

    git pull --all

    for branch in $(git branch --all | grep '^\s*remotes' | egrep --invert-match '(:?HEAD|master)$'); do
        git branch --track "${branch##*/}" "$branch"
    done


    echo "Creating the remote repository on blob storage..."
    az storage container create --name "$repo"

    echo "Uploading the repository to blob storage..."
    az storage blob upload-batch -d "$repo" -s ../"$repo"

    # In case cd command faild...
    cd - || return
done