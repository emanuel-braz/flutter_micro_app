import '../fma_app_config.dart';

// Example of a custom implementation of a remote config
// This is just a stub for the real implementation
class FirebaseRemoteConfigExample extends FmaRemoteConfig {
  final FirebaseRemoteConfigStub firebaseRemoteConfigStub;

  FirebaseRemoteConfigExample(this.firebaseRemoteConfigStub)
      : super(
            getAll: firebaseRemoteConfigStub.getAll, // Optional
            getInt: firebaseRemoteConfigStub.getInt, // Optional
            getDouble: firebaseRemoteConfigStub.getDouble, // Optional
            getString: firebaseRemoteConfigStub.getString, // Optional
            getBool: firebaseRemoteConfigStub.getBool, // Optional
            getValue: firebaseRemoteConfigStub.getValue // Optional
            );
}

class FirebaseRemoteConfigStub {
  Map<String, dynamic> getAll() => <String, dynamic>{'foo': 'bar'};
  int getInt(String key) => 42;
  double getDouble(String key) => 3.14;
  String getString(String key) => 'foo';
  bool getBool(String key) => false;
  dynamic getValue(String key) {}
}
