analyze:
	@flutter format . \
	&& flutter analyze \
	&& flutter test \
	&& dart pub global activate pana \
	&& dart pub global run pana .

publish:
	@git checkout master && dart pub publish