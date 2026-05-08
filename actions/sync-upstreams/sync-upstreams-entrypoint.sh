#!/bin/bash

set -eu

# shellcheck disable=SC1091
source /common.sh

set_git_safe_directory

# Transform the input sources into a comma separated list
INPUT_SOURCES=$(echo "${INPUT_SOURCES}" | tr '\n' ' ' | tr -s ' ' | sed 's/ *$//' | tr ' ' ',')

# Build the argument list as an array so values are passed verbatim to
# complyscribe and are not re-parsed by the shell. Using `eval` on an
# interpolated command string would let shell metacharacters in any
# INPUT_* value execute as code (GHSA-r47v-2m6p-qq32).
args=(
    --sources="${INPUT_SOURCES}"
    --include-models="${INPUT_INCLUDE_MODELS}"
    --exclude-models="${INPUT_EXCLUDE_MODELS}"
    --commit-message="${INPUT_COMMIT_MESSAGE}"
    --branch="${INPUT_BRANCH}"
    --file-patterns="${INPUT_FILE_PATTERNS}"
    --committer-name="${INPUT_COMMIT_USER_NAME}"
    --committer-email="${INPUT_COMMIT_USER_EMAIL}"
    --author-name="${INPUT_COMMIT_AUTHOR_NAME}"
    --author-email="${INPUT_COMMIT_AUTHOR_EMAIL}"
    --repo-path="${INPUT_REPO_PATH}"
    --target-branch="${INPUT_TARGET_BRANCH}"
    --config="${INPUT_CONFIG}"
)

# Conditionally include flags
if [[ ${INPUT_SKIP_VALIDATION} == true ]]; then
    args+=(--skip-validation)
fi

if [[ ${INPUT_DRY_RUN} == true ]]; then
    args+=(--dry-run)
fi

if [[ ${INPUT_DEBUG} == true ]]; then
    args+=(--debug)
fi

complyscribe sync-upstreams "${args[@]}"
