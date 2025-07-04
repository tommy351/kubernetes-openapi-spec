go_os = $(shell go env GOOS)
go_arch = $(shell go env GOARCH)

# NOTE: Not all Kubernetes versions exist, check the URL below for supported versions.
# https://github.com/kubernetes-sigs/controller-tools/blob/main/envtest-releases.yaml
all: \
	openapi/1.24.2.json \
	openapi/1.25.0.json \
	openapi/1.26.1.json \
	openapi/1.27.1.json \
	openapi/1.28.0.json \
	openapi/1.29.5.json \
	openapi/1.30.3.json \
	openapi/1.31.0.json \
	openapi/1.32.0.json \
	openapi/1.33.0.json

openapi/%.json: tmp/kubebuilder-tools-%-$(go_os)-$(go_arch)
	mkdir -p $(dir $@)
	KUBEBUILDER_ASSETS=$(abspath $<) go run . -output $(abspath $@)

tmp/kubebuilder-tools-%-$(go_os)-$(go_arch):
	mkdir -p $@
	curl -L "https://github.com/kubernetes-sigs/controller-tools/releases/download/envtest-v$*/envtest-v$*-$(go_os)-$(go_arch).tar.gz" | tar --strip-components=2 -xz -C $@ controller-tools/envtest

.PHONY: clean
clean:
	rm -rf tmp
