.PHONY: all build clean repl fmt deps

all: build

build:
	dune build

test:
	dune runtest

clean:
	dune clean

repl:
	dune utop

fmt:
	dune build @fmt --auto-promote

deps:
	opam install --deps-only .

install:
	dune install

uninstall:
	dune uninstall
