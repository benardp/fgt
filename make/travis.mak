build:
	mkdir build; cd build; \
	    cmake .. -DBUILD_TESTS=ON -DCMAKE_BUILD_TYPE=Release; \
	    make

test:
	build/bin/fgt-test

install:
	cd build; sudo make install


.PHONY: build test install