#!/usr/bin/env bash

# Copyright 2018 The Tekton Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script calls out to scripts in tektoncd/plumbing to setup a cluster
# and deploy Tekton Pipelines to it for running integration tests.

# TODO: fix common.sh and  enable set  -euo pipefail
#set -euxo pipefail

source $(dirname $0)/e2e-common.sh

ci_run && {
  header "Setting up environment"
  initialize $@
}

# FIXME(vdemeester) To Do later
# install_pipeline_crd

# Run the integration tests
ci_run && {
  header "Running Go e2e tests"
  local failed=0
  go_test_e2e ./test || failed=1
  (( failed )) && fail_test
}

go build github.com/tektoncd/cli/cmd/tkn

tkn() {
 ./tkn "$@"
}


# command before creation of resources
# ensure that the cluster does not have any pipeline resources and that all
# tkn commands would fail
must_fail  "describe pipeline before installing crd" tkn pipeline describe foo
must_fail  "describe pipelinerun before installing crd" tkn pipelinerun describe foo

must_fail  "list pipelinerun for pipeline foo before installing crd" tkn pipelinerun list foo
must_fail  "list pipelines before installing crd" tkn pipeline list
must_fail  "list task before installing crd" tkn task list
must_fail  "list taskrun before installing crd" tkn taskrun list
must_fail  "list taskrun for task foo before installing crd" tkn taskrun list foo

must_fail  "logs of pipelinerun before installing crd" tkn pipelinerun logs foo
must_fail  "logs of taskrun before installing crd" tkn taskrun logs foo


ci_run &&{
    install_pipeline_crd
}

# listing objects after CRD is created should not fail
run_test  "list pipeelinerun for pipeline foo" tkn taskrun list foo
run_test  "list pipelinerun"  tkn pipelinerun list
run_test  "list pipelines" tkn pipeline list
run_test  "list task" tkn task list
run_test  "list taskrun for task foo" tkn taskrun list foo
run_test  "list taskrun" tkn taskrun list

echo "..............................."

# fetching objects that do not exist must fail
must_fail  "describe pipeline that does not exist" tkn pipeline describe foo
must_fail  "describe pipelinerun that does not exist" tkn pipelinerun describe foo
must_fail  "logs of pipelinerun that does not exist" tkn pipelinerun logs foo
must_fail  "logs of taskrun that does not exist" tkn taskrun logs foo
echo "....................."

# change default namespace to tektoncd
kubectl create namespace tektoncd
kubectl config set-context $(kubectl config current-context) --namespace=tektoncd

# create pipeline, pipelinerun, task, and taskrun
kubectl apply -f ./test/resources/output-pipelinerun.yaml
kubectl apply -f ./test/resources/task-volume.yaml


echo Waiting for resources to be ready
echo ---------------------------------
wait_until_ready 600 pipelinerun/output-pipeline-run || exit 1
wait_until_ready 600 taskrun/test-template-volume  || exit 1
echo ---------------------------------

# commands after install_pipeline
echo Running tests
echo ---------------------------------
run_test  "list pipelinerun for pipeline output-pipeline" tkn pipelinerun list output-pipeline
run_test  "list pipelinerun" tkn pipelinerun list
run_test  "list pipelines" tkn pipeline list
run_test  "list task" tkn task list
run_test  "list taskrun for pipeline task-volume" tkn taskrun list task-volume
run_test  "list taskrun" tkn taskrun list

run_test  "describe pipeline" tkn pipeline describe output-pipeline
run_test  "describe pipelinerun" tkn pipelinerun describe output-pipeline-run

run_test  "show logs" tkn pipelinerun logs output-pipeline-run
run_test  "show logs" tkn taskrun logs test-template-volume
run_test  "list pipelineresources" tkn resource list
run_test  "describe pipelineresource" tkn resource desc skaffold-git

success
