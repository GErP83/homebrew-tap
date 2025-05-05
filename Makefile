SHELL=/bin/bash

.PHONY: all clean rpm deb

baseUrl = https://raw.githubusercontent.com/BinaryBirds/github-workflows/refs/heads/main/scripts

test:
	swift test --parallel

language:
	curl -s $(baseUrl)/check-unacceptable-language.sh | bash

lint:
	curl -s $(baseUrl)/run-swift-format.sh | bash

format:
	curl -s $(baseUrl)/run-swift-format.sh | bash -s -- --fix

release:
	swift package update && swift build -c release

install: release
	install .build/Release/testify /usr/local/bin/testify

uninstall:
	rm /usr/local/bin/testify


# Generic check to ensure required args are passed
check-vars:
	@if [ -z "$(NAME)" ] || [ -z "$(VERSION)" ]; then \
	  echo "Usage: make <target> NAME=your-lib VERSION=1.0.0"; \
	  exit 1; \
	fi

all: rpm deb

rpm: check-vars
	@echo "➡️  Building RPM for $(NAME) version $(VERSION)"
	./scripts/build-rpm.sh $(NAME) $(VERSION)

deb: check-vars
	@echo "➡️  Building DEB for $(NAME) version $(VERSION)"
	./scripts/build-deb.sh $(NAME) $(VERSION)

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	rm -rf build-deb
