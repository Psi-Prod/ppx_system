.PHONY: all build clean doc fmt deps

all: build

build:
	dune build

test:
	dune runtest

clean:
	dune clean

fmt:
	dune build @fmt --auto-promote

deps:
	opam install --deps-only .
