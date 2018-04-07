test:
	swift test

build:
	swift build -c release -Xswiftc -static-stdlib
	
copy:
	cp .build/release/Icetea ~/bin/icetea

install:
	make build
	make copy