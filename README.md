# pre-commit-kustomize

pre-commit hook which runs kustomize in a docker image. Docker image is based on https://github.com/lyft/kustomizer, but added github.com into known hosts and not running this image as root. This modification allows for remote refs in your kustomize. Other git providers will probably not work and require further changes. Please raise an issue.

## Example of .pre-commit-config.yaml that verifies that 4 overlays are not broken
```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
- repo: https://github.com/pre-commit/pre-commit-hooks
  rev: v3.3.1
  hooks:
  - id: check-yaml
    args: [--allow-multiple-documents]
  - id: check-added-large-files
- repo: https://github.com/liskl/pre-commit-kustomize
  rev: main
  hooks:
  - id: kustomize
    name: kustomize-dev
    args: [deploy/kustomize/overlays/dev]
    verbose: false
  - id: kustomize
    name: kustomize-stage
    args: [deploy/kustomize/overlays/stage]
    verbose: false
  - id: kustomize
    name: kustomize-demo
    args: [deploy/kustomize/overlays/demo]
    verbose: false
  - id: kustomize
    name: kustomize-prod
    args: [deploy/kustomize/overlays/prod]
    verbose: false
