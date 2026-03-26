.PHONY: test

test:
	crystal spec

release: shards
	crystal build src/tamandua.cr --release --no-debug --progress -o tamandua

shards:
	shards install --production

