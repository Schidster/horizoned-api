#!/bin/sh
# Replace image form environment variable in task-definition
sed -i "s/api:latest/$API_IMAGE/g" terraform/task-definition.json
sed -i "s/server:latest/$SERVER_IMAGE/g" terraform/task-definition.json
