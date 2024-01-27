analyze:
	@dart format . \
	&& dart analyze \
	&& flutter test \
	&& dart pub global activate pana \
	&& dart pub global run pana .

publish:
	@git checkout master && git pull && dart pub publish