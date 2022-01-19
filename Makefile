devcon_init:
	@echo 'init devcontainer'
	sudo chown vscode:vscode -R /bundle
	sudo chown vscode:vscode -R .
	npm install
	npm audit fix
	npx husky install
	bundle check || bundle

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


lint:
	rubocop

lint_fix:
	rubocop -A
