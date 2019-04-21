PREFIX?=${CURDIR}
NIMBLE_DIR?=${CURDIR}/NIMBLE
export NIMBLE_DIR
# or use --nimbleDir:${NIMBLE_DIR} everywhere
NIMBLE_INSTALL=nimble install --debug -y

quick:
	nim c -r tests/t_kmers.nim
integ:
	${MAKE} -C integ-tests/
help:
	nimble -h
	nimble tasks
test:
	nimble test --debug --lineCmd  # uses "tests/" directory by default
install:
	${NIMBLE_INSTALL}
pretty:
	find . -name '*.nim' | xargs -L1 nimpretty --indent=4

.PHONY: tests
