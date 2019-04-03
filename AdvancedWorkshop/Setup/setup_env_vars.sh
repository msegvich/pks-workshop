#!/usr/bin/bash

# Set user index in advance
export USER_INDEX="1"
export PKS_API=api.pks.pcf-apps.com
export PKS_CLUSTER_NAME=user$USER_INDEX
export PKS_CLUSTER=$PKS_CLUSTER_NAME.pks.pcf-apps.com
export HARBOR_REGISTRY_URL="harbor.pks.pcf-apps.com"
export HARBOR_USERNAME="developer"
export HARBOR_PASSWORD="Pivotal1"
export HARBOR_EMAIL="dev@acme.org"
