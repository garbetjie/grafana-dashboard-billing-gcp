#!/usr/bin/env bash

set -e

jq '
  .panels[].targets[]? |= if .table? != null then .table = "" else . end |
  .panels[].targets[]? |= if .project? != null then .project = "" else . end |
  .templating.list[] |= if .name == "dataset" then (.options = [] | .current.text = "${VAR_DATASET}" | .current.value = "${VAR_DATASET}" | .query = "${VAR_DATASET}") else . end |
  .panels[] |= if .id == 7 then .datasource = "${DS_BIGQUERY}" else . end |
  .title = "Google Cloud Billing Costs" |
  .__inputs |= . + [({} | .name = "VAR_DATASET" | .type = "constant" | .label = "Dataset containing billing export (Format: $project.$dataset)")] |
  del(.uid, .version) |
  del(.__inputs[]|select(.name == "DS_STACKDRIVER")) |
  del(.__requires[]|select(.type == "datasource" and .id == "stackdriver"))' raw.json > dashboard.json

rm -f raw.json
