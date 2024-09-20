#!/usr/bin/env bash

set -e

# Ensure GPG_PRIVATE_KEY is set
if [ -z "${GPG_PRIVATE_KEY}" ]; then
  echo "GPG_PRIVATE_KEY must be set."
  exit 1
fi

echo "${GPG_PRIVATE_KEY}" | gpg --import

deb-s3 $@
