#!/bin/bash
set -e

# Assuming you are running this from a prepared virtual environment
PROJECT_ROOT=$(cd "$(dirname $0)/../.." && pwd)
cd $PROJECT_ROOT
c="python osc_sdk/sdk.py"

echo -n "$(basename $0): "

# All calls must fail with a bad auth method even if accesskey method is available
# This env variable must be set:
# OSC_TEST_LOGIN
# OSC_TEST_PASSWORD

if [ -z "$OSC_TEST_LOGIN" ]; then
    echo "error, OSC_TEST_LOGIN must be set"
    exit 1
fi
if [ -z "$OSC_TEST_PASSWORD" ]; then
    echo "error, OSC_TEST_PASSWORD must be set"
    exit 1
fi

function clean_tmp() {
    rm -rf /tmp/osc-cli_* || true
}

# Ephemeral AK duration test
AK_LIFETIME_S=20
clean_tmp

for i in {0..3}; do
    sleep 5
    # First call to setup temp AK/SK
    $c api ReadNets --authentication-method=ephemeral --ephemeral-ak-duration $AK_LIFETIME_S --login "$OSC_TEST_LOGIN" --password "$OSC_TEST_PASSWORD" &> /dev/null || { echo "Init error (step $i)"; exit 1; }
    # Should succeed
    $c api ReadNets --authentication-method=ephemeral &> /dev/null || { echo "API error (step $i)"; exit 1; }
    # Wait for AK to expire
    sleep $AK_LIFETIME_S
    # Should now fail
    $c api ReadNets --authentication-method=ephemeral &> /dev/null && { echo "Auth should have failed (step $i)"; exit 1; }
done
	 
clean_tmp

echo "OK"
