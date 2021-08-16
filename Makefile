# Use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: projects
projects:
	@source scripts/projects.sh
