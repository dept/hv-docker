#!/bin/bash

# Assuming NODE_VERSION is set as an environment variable or passed as an argument
if [ -z "$NODE_VERSION" ]; then
    echo "NODE_VERSION is not set"
    exit 1
fi

# Check if NODE_VERSION is >= 18
if [ "$NODE_VERSION" -ge 18 ]; then
   apt-get update -qq
   apt-get install -y ca-certificates curl gnupg
   mkdir -p /etc/apt/keyrings
   curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
   echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
   apt-get update -qq
else
    # Existing logic for NODE_VERSION < 18
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
fi

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -;
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list;
apt-get update -qq && apt-get install -qq --no-install-recommends nodejs yarn pngquant
apt-get clean
rm -rf /var/lib/apt/lists/*;
