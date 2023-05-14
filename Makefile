go_os = $(shell go env GOOS)
go_arch = $(shell go env GOARCH)

# NOTE: Not all Kubernetes versions exist, check the URL below for supported versions.
# https://storage.googleapis.com/kubebuilder-tools
all: openapi/1.15.5.json openapi/1.21.2.json openapi/1.24.2.json openapi/1.25.0.json openapi/1.26.1.json openapi/1.27.1.json

openapi/%.json: tmp/kubebuilder-tools-%-$(go_os)-$(go_arch)
	mkdir -p $(dir $@)
	KUBEBUILDER_ASSETS=$(abspath $<) go run . -output $(abspath $@)

tmp/kubebuilder-tools-%-$(go_os)-$(go_arch):
	mkdir -p $@
	curl -L "https://storage.googleapis.com/kubebuilder-tools/kubebuilder-tools-$*-$(go_os)-$(go_arch).tar.gz" | tar --strip-components=2 -xz -C $@ kubebuilder/bin

.PHONY: clean
clean:
	rm -rf tmp openapi
