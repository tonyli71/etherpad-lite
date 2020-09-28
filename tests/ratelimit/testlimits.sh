#!/usr/bin/env bash

#sending changesets every 100ms should not trigger ratelimit
node send_changesets.js http://127.0.0.1:8081/p/BACKEND_TEST_padloadtest 100
if [[ $? -ne 0 ]];then
  echo "FAILED: ratelimit was triggered when sending every 100 ms"
  exit 1
fi

#sending changesets every 99ms should trigger ratelimit
node send_changesets.js http://127.0.0.1:8081/p/BACKEND_TEST_padloadtest 99
if [[ $? -ne 1 ]];then
  echo "FAILED: ratelimit was not triggered when sending every 99 ms"
  exit 1
fi

#sending changesets every 100ms should not trigger ratelimit
node send_changesets.js http://127.0.0.1:8081/p/BACKEND_TEST_padloadtest 100 > /tmp/proxy_cs.exitcode&

#sending changesets every 100ms directly without proxy should not trigger changeset
node send_changesets.js http://127.0.0.1:9000/p/BACKEND_TEST_padloadtest 100 > /tmp/direct_cs.exitcode&

sleep 15; #let the scripts finish

if [[ "$(cat /tmp/direct_cs.exitcode)" == "1" || "$(cat /tmp/proxy_cs.exitcode)" == "1" ]];then
  echo "FAILED: ratelimit was triggered"
  exit 1
fi
