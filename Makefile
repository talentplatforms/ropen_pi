################################################################################
# DEV-CONTAINER

devcon_init:
	@echo 'init devcontainer'
	make devcon_chown
	npm install
	npm audit fix
	npx husky install
	bundle check || bundle

devcon_chown:
	sudo chown vscode:vscode -R /bundle
	sudo chown vscode:vscode -R .

################################################################################
# RELEASE STUFF

minor:
	bump minor

patch:
	bump patch

major:
	bump major

build:
	gem build ropen_pi.gemspec

_VERSION=$(shell bump current | sed 's/Current version: //')
push:
	gem push ropen_pi-${_VERSION}.gem

################################################################################
# HELPER

lint:
	rubocop

lint_fix:
	rubocop -A
