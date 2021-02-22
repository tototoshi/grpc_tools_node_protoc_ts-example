out := out
npm_bin := $(shell npm bin)
grpc_tools_node_protoc := $(npm_bin)/grpc_tools_node_protoc
grpc_tools_node_protoc_plugin := $(npm_bin)/grpc_tools_node_protoc_plugin
protoc-gen-ts := $(npm_bin)/protoc-gen-ts

.PHONY: npm_install gen test clean

npm_install:
	npm install

gen: npm_install
	mkdir -p $(out)
	$(grpc_tools_node_protoc) \
		--js_out=import_style=commonjs,binary:$(out) \
		--grpc_out=grpc_js:$(out) \
		--plugin=protoc-gen-grpc=$(grpc_tools_node_protoc_plugin) \
		-I . \
		test.proto
	$(grpc_tools_node_protoc) \
		--plugin=protoc-gen-ts=$(protoc-gen-ts) \
		--ts_out=$(out) \
		-I . \
		test.proto

test: clean gen
	cd $(out) && \
	test -f test_grpc_pb.d.ts && \
	test -f test_grpc_pb.js && \
	test -f test_pb.d.ts && \
	test -f test_pb.js

clean:
	rm -rf $(out)
