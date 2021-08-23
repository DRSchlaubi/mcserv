generate:
	dart run build_runner build

build_native:
	cd chmod_lib && cmake . && make
