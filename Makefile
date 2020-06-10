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
