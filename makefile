analyze:
	@flutter format . \
	&& flutter analyze \
	&& flutter test \
	&& dart pub global activate pana \
	&& dart pub global run pana .

publish:
	@dart pub publish