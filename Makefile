SHELL=/bin/bash

.PHONY: all clean rpm

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


rpm:
	@if [ -z "$(NAME)" ] || [ -z "$(VERSION)" ]; then \
	  echo "Usage: make rpm NAME=your-lib VERSION=1.0.0"; \
	  exit 1; \
	fi
	@echo "Invoking build-rpm.sh with NAME=$(NAME) VERSION=$(VERSION)"
	./scripts/build-rpm.sh $(NAME) $(VERSION)

clean:
	@echo "Cleaning RPM build artifacts..."
	rm -rf ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
