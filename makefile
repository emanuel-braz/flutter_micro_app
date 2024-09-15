analyze:
	@dart format . \
	&& dart analyze \
	&& flutter test \
	&& dart pub global activate pana \
	&& dart pub global run pana .

build-extension:
	@cd fma_devtools_extension && dart run devtools_extensions build_and_copy --source=. --dest=../extension/devtools

publish:
	@git checkout master && git pull && dart pub publish