# Makefile for wtf-bot
# Tested with GNU Make 3.8.1
MAKEFLAGS += --warn-undefined-variables
SHELL        	:= /usr/bin/env bash -e
CI_ARG      	:= $(CI)

.DEFAULT_GOAL := help

# cribbed from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html and https://news.ycombinator.com/item?id=11195539
help:  ## Prints out documentation for available commands
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST)

## Pip / Python

.PHONY: python-install
# python-install recipe all has to run in a single shell because it's running inside a virtualenv
python-install:  requirements.txt dev-requirements.txt ## Sets up your python environment for the first time (only need to run once)
	pip install virtualenv ;\
	virtualenv -p ~/.pyenv/shims/python env ;\
	source env/bin/activate ;\
	PYTHONPATH=./app
	echo shell env activated ;\
	pip install --require-hashes -r requirements.txt -r dev-requirements.txt ;\
	echo Finished install ;\
	echo Please activate the virtualenvironment with: ;\
	echo source env/bin/activate

# Errors out if VIRTUAL_env is not defined and we aren't in a CI environment.
.PHONY: check-env
check-env:
ifndef VIRTUAL_ENV
ifneq ($(CI_ARG), true)
	$(error VIRTUAL_ENV is undefined, meaning you aren't running in a virtual environment. Fix by running: 'source env/bin/activate') endif
endif
endif

requirements.txt: requirements.in
	pip-compile --generate-hashes requirements.in --output-file $@

dev-requirements.txt: dev-requirements.in
	pip-compile --generate-hashes dev-requirements.in --output-file $@

.PHONY: pip-upgrade
pip-upgrade:  ## Upgrade all python dependencies
	pip-compile --upgrade --generate-hashes requirements.in --output-file requirements.txt
	pip-compile --upgrade --generate-hashes dev-requirements.in --output-file dev-requirements.txt

SITE_PACKAGES := $(shell pip show pip | grep '^Location' | cut -f2 -d ':')
$(SITE_PACKAGES): requirements.txt dev-requirements.txt check-env
ifeq ($(CI_ARG), true)
	@echo "Do nothing; assume python dependencies were installed already"
else
	pip-sync requirements.txt dev-requirements.txt
endif

.PHONY: pip-install
pip-install: $(SITE_PACKAGES)

## Test targets
.PHONY: unit-test
unit-test: pip-install  ## Run python unit tests
	python -m pytest -v --cov --cov-report term --cov-report xml --cov-report html

.PHONY: flake8
flake8: pip-install 	## Run Flake8 python static style checking and linting
	@echo "flake8 comments:"
	flake8 --statistics .

.PHONY: test
test: unit-test flake8 ## Run unit tests, static analysis
	@echo "All tests passed."  # This should only be printed if all of the other targets succeed

.PHONY: clean
clean:  ## Delete any directories, files or logs that are auto-generated, except node_modules and python packages
	rm -rf results
	rm -rf .pytest_cache
	rm -f .coverage

.PHONY: deepclean
deepclean: clean  ## Delete python packages and virtualenv. You must run 'make python-install' after running this.
	rm -rf env
	rm -rf htmlcov
	rm coverage.* 
	@echo virtualenvironment was deleted. Type 'deactivate' to deactivate the shims.
