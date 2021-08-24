generate:
	dart run build_runner build

build_native:
	cd chmod_lib && cmake . && make

build_arb:
	pub run intl_translation:extract_to_arb --output-dir=i18n \
       bin/intl/localizations.dart

read_arb:
	 pub run intl_translation:generate_from_arb --output-dir=bin/intl --no-use-deferred-loading bin/intl/localizations.dart i18n/intl_*.arb
