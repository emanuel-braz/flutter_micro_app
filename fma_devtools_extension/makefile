run:
	@flutter run -d chrome --dart-define=use_simulated_environment=true

deploy:
	@dart run devtools_extensions build_and_copy --source=. --dest=../extension/devtools

deploy-manual:
	@flutter build web --web-renderer canvaskit --pwa-strategy=offline-first --release --no-tree-shake-icons \
	&& cp -rf build/web ../extension/devtools/build