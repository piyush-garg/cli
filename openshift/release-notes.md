# OpenShift Pipelines 1.6

# Tekton CLI v0.21.0

### Features ✨

* Support output option for pipeline/task start command [#1326](https://github.com/tektoncd/cli/pull/1326)
* Authenticate to registries with podman's config [#1430](https://github.com/tektoncd/cli/pull/1430)
* Add --keep-since flag to taskrun delete [#1435](https://github.com/tektoncd/cli/pull/1435)
* Delete resource using parent resource and keep-since [#1443](https://github.com/tektoncd/cli/pull/1443)
* Adds support for triggers resources to work with v1beta1 resources [#1446](https://github.com/tektoncd/cli/pull/1446) 
[#1449](https://github.com/tektoncd/cli/pull/1449) [#1450](https://github.com/tektoncd/cli/pull/1450)
[#1454](https://github.com/tektoncd/cli/pull/1454) [#1455](https://github.com/tektoncd/cli/pull/1455)
* Add ignore-running flag to tkn pr/tr delete [#1445](https://github.com/tektoncd/cli/pull/1445)
* Add create command for tkn task/clustertask [#1359](https://github.com/tektoncd/cli/pull/1359)

### Deprecation 🧹

- Support for all clustertask/task/taskrun/pipeline/pipelinerun cmd with v1alpha1 resources has been deprecated 
and will be removed after two releases.

### Fixes 🐛

* Fix terminal not available after logs cmd in retries pipeline [#1459](https://github.com/tektoncd/cli/issues/1459)

# Tekton CLI v0.20.0

### Features ✨

* Add --keep-since flag to pipelinerun delete [#1392](https://github.com/tektoncd/cli/pull/1392)
* Add pipelinerun delete by label [#1402](https://github.com/tektoncd/cli/pull/1402)
* Get tekton components version from configmap [#1393](https://github.com/tektoncd/cli/pull/1393)

### Fixes 🐛

* Fix client version output with --component option [#1408](https://github.com/tektoncd/cli/pull/1408)
* Fix TaskRun order in tkn pr logs [#1385](https://github.com/tektoncd/cli/pull/1385)
