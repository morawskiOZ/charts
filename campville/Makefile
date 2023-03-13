ENV ?= production
VALUES_FILE = values.yaml
CHART_FILE = Chart.yaml
version ?= $(shell yq e ".version" ${CHART_FILE})
BUILD_ENV ?= production

show:
	@echo "ENV: $(ENV)"
	@echo "VALUES_FILE: $(VALUES_FILE)"
	@echo "CHART_FILE: $(CHART_FILE)"
	@echo "version: $(version)"

init:
	pre-commit install

code-check:
	pre-commit run --all-files

generate-config:
	@echo "Generating secrets $(ENV)..."

ifeq ($(ENV),production)
	$(eval VALUES_FILE=values.yaml)
else
	$(eval VALUES_FILE=values.${ENV}.yaml)
	$(eval BUILD_ENV=$(shell yq e ".env" ${VALUES_FILE}))
endif


	kubectl create secret generic campville-$(BUILD_ENV)-secrets --dry-run=client --from-env-file=env/${ENV}/.env -o yaml | \
	kubeseal \
	--controller-name=sealed-secrets-controller \
	--controller-namespace=kube-system \
	--scope cluster-wide \
	--format yaml | yq e '.spec.encryptedData' - > env/${ENV}/secrets.yaml

generate-config-stage: export ENV=stage
generate-config-stage: generate-config

generate-config-production: generate-config

lint:
	@helm lint . -f values.yaml
	@helm lint . -f values.stage.yaml

build: lint
	@helm package .
